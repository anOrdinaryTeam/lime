#include <app/FramePacer.h>
#include <bindings/opengl/OpenGLBindings.h>

#ifdef HX_WINDOWS

#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include <dwmapi.h>

#include <atomic>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <mutex>
#include <thread>
#include <vector>


namespace lime {


	// Minimal D3DKMT ABI, resolved from gdi32.dll via GetProcAddress
	typedef LONG NTSTATUS;
	typedef ULONG D3DKMT_HANDLE;

	typedef struct {

		LUID AdapterLuid;
		D3DKMT_HANDLE hAdapter;

	} FP_OpenAdapterFromLuid;

	typedef struct {

		D3DKMT_HANDLE hAdapter;

	} FP_CloseAdapter;

	typedef struct {

		D3DKMT_HANDLE hAdapter;
		D3DKMT_HANDLE hDevice;
		UINT VidPnSourceId;

	} FP_WaitForVerticalBlankEvent;

	typedef struct {

		D3DKMT_HANDLE hAdapter;
		UINT VidPnSourceId;
		BOOL InVerticalBlank;
		UINT ScanLine;

	} FP_GetScanLine;

	typedef NTSTATUS (APIENTRY *FP_OpenAdapterFromLuidFunc) (FP_OpenAdapterFromLuid*);
	typedef NTSTATUS (APIENTRY *FP_CloseAdapterFunc) (FP_CloseAdapter*);
	typedef NTSTATUS (APIENTRY *FP_WaitForVerticalBlankEventFunc) (FP_WaitForVerticalBlankEvent*);
	typedef NTSTATUS (APIENTRY *FP_GetScanLineFunc) (FP_GetScanLine*);
	typedef HRESULT (WINAPI *FP_DwmGetCompositionTimingInfoFunc) (HWND, DWM_TIMING_INFO*);
	typedef BOOL (WINAPI *FP_MiniDumpWriteDumpFunc) (HANDLE, DWORD, HANDLE, int, void*, void*, void*);


	static const Uint64 ANCHOR_STALE_NS = 200000000ULL;

	// hardcoded tuning -- edit and rebuild
	// D3DKMT wakes after the edge; PLL_EPS carries the wake latency, the bias shifts the phase
	static const Uint64 PLL_EPS_NS = 100ULL;
	static const Uint64 PLL_BIAS_NS = 200000ULL;
	// windowed: DWM's compose deadline sits ~3 ms before the edge; later presents
	// slip one refresh
	static const Uint64 WINDOWED_EPS_NS = 3500000ULL;
	// GPU budget on top of the CPU body; lower = line closer to the bottom, higher = more headroom
	static const Uint64 DEFAULT_GPU_MARGIN_NS = 1000000ULL;
	// fullscreen only: present phase in percent of one refresh (env LIME_PRESENT_PHASE_PCT)
	static const Uint64 PRESENT_PHASE_PCT_DEFAULT = 5;
	static const Uint64 STAT_WINDOW_NS = 10000000000ULL;


	struct FramePacerImpl {

		// gdi32 / dwmapi entry points
		FP_OpenAdapterFromLuidFunc openAdapter;
		FP_CloseAdapterFunc closeAdapter;
		FP_WaitForVerticalBlankEventFunc waitVBlank;
		FP_GetScanLineFunc getScanLine;
		FP_DwmGetCompositionTimingInfoFunc dwmTiming;
		Uint64 qpcFreq;

		// window / display target
		SDL_Window* sdlWindow;
		HWND hwndValue;
		Uint64 periodNs;
		std::atomic<Uint32> requestGen;
		std::atomic<bool> useDwm;
		// API pacing mode: -1 auto, 0 off, 1 adaptive, 2 locked
		std::atomic<int> mode;
		bool prevLockMode;

		// anchor thread output (SDL clock)
		std::atomic<Uint64> anchorPeriod;  // hardware period when it is trusted
		std::atomic<long long> dwmGap;     // DWM vblank stamp minus the wake clock (diagnostic)
		std::atomic<Uint64> vbAlive;
		std::atomic<Uint64> predEdge;      // PLL estimate of the last wake edge
		std::atomic<Uint64> realPeriod;
		std::atomic<bool> rebindHint;
		std::atomic<bool> displayBound;
		std::atomic<Uint64> periodOverride;
		std::atomic<D3DKMT_HANDLE> scanAdapter;
		std::atomic<UINT> scanSource;

		// anchor thread state
		std::thread* anchorThread;
		std::atomic<bool> running;

		// watchdog: a hung main thread gets one stack dump for diagnosis
		std::thread* watchdogThread;
		std::atomic<Uint64> heartbeat;
		std::atomic<int> stallPhase;      // 0 outside, 1 frame-start wait, 2 swap wait, 3 swap
		std::atomic<bool> hangDumped;
		std::atomic<Uint64> lastStallLog;
		FP_MiniDumpWriteDumpFunc dumpWriter;
		HANDLE mainThread;

		D3DKMT_HANDLE hAdapter;
		UINT vidPnSourceId;
		bool adapterOpen;
		Uint32 appliedLocal;
		int failStreak;
		int divergeCount;
		int divergeRound;
		Uint64 lastVbForPeriod;
		Uint64 lastRebindNs;
		Uint64 lastDwmNs;

		// game thread pacing
		DWORD lastRefreshRate;
		HMONITOR lastMonitor;
		bool fullscreenMode;
		bool prevFullscreenMode;
		bool gateActive;
		Uint64 lastCheckNs;
		Uint64 framePeriod;
		Uint64 frameEps;
		Uint64 targetEdge;
		Uint64 nextTarget;
		int gridStep;
		FrameWaitState startWait;
		FrameWaitState swapWait;
		Uint64 frameStartT0;
		Uint64 readyAt;
		Uint64 presentAt;
		Uint64 swapStartAt;
		Uint64 swapEndAt;
		Uint64 swapLead;
		Uint64 swapP95;
		Uint64 swapMax;
		Uint64 swapRing[32];
		int swapIndex;
		int swapSamples;
		Uint64 lastPresentAt;
		long long presentErr;
		double bodyEst;
		Uint64 bodyRing[64];
		int bodyIndex;
		int bodyCount;
		Uint64 gpuMargin;
		Uint64 baseMargin;
		Uint64 frameBase;
		// cached swap interval: the driver query costs a WGL call per frame
		int swapInterval;
		Uint64 lastSwapCheckNs;
		GLuint gpuQueries[3];
		bool gpuQueryInit;
		bool gpuQueryActive;
		int gpuQueryIndex;
		int gpuSamples;
		double gpuBody;
		double gpuRef;
		Uint64 lastTarget;
		bool pacedLogged;
		Uint64 lastStartNs;
		void* lastGlContext;
		bool pacerOff;
		// LIME_FRAMEPACER_LOG=1 enables framepacer.log and the stats behind it
		bool logEnabled;
		Uint64 presentPhasePct;

		// raster position sampled around the swap: v = blanking, a = active scan
		UINT beamStartLine;
		bool beamStartBlank;
		UINT beamEndLine;
		bool beamEndBlank;
		bool beamValid;
		bool beamEndValid;

		// stats window
		Uint32 swapCount;
		Uint32 tearCount;
		Uint32 lateCount;
		long long errSum;
		long long errMin;
		long long errMax;
		Uint32 ivRing[256];
		Uint32 ivIndex;
		Uint32 ivCount;
		Uint64 statWindow;


		FramePacerImpl () {

			openAdapter = nullptr;
			closeAdapter = nullptr;
			waitVBlank = nullptr;
			getScanLine = nullptr;
			dwmTiming = nullptr;
			qpcFreq = 0;

			sdlWindow = nullptr;
			hwndValue = nullptr;
			periodNs = 0;
			requestGen = 0;
			useDwm = false;
			mode = -1;
			prevLockMode = false;

			anchorPeriod = 0;
			dwmGap = 0;
			vbAlive = 0;
			predEdge = 0;
			realPeriod = 0;
			rebindHint = false;
			displayBound = false;
			periodOverride = 0;

			anchorThread = nullptr;
			running = false;
			watchdogThread = nullptr;
			heartbeat = 0;
			stallPhase = 0;
			hangDumped = false;
			lastStallLog = 0;
			dumpWriter = nullptr;
			mainThread = nullptr;

			if (!DuplicateHandle (GetCurrentProcess (), GetCurrentThread (), GetCurrentProcess (), &mainThread,
				THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT | THREAD_QUERY_INFORMATION, FALSE, 0)) {

				mainThread = nullptr;

			}
			hAdapter = 0;
			vidPnSourceId = 0;
			adapterOpen = false;
			appliedLocal = 0;
			failStreak = 0;
			divergeCount = 0;
			divergeRound = 0;
			lastVbForPeriod = 0;
			lastRebindNs = 0;
			lastDwmNs = 0;

			lastRefreshRate = 0;
			lastMonitor = nullptr;
			fullscreenMode = false;
			prevFullscreenMode = false;
			gateActive = false;
			lastCheckNs = 0;
			framePeriod = 0;
			frameEps = 0;
			targetEdge = 0;
			nextTarget = 0;
			gridStep = 1;
			frameStartT0 = 0;
			readyAt = 0;
			presentAt = 0;
			swapStartAt = 0;
			swapEndAt = 0;
			swapLead = 300000ULL;
			swapP95 = 0;
			swapMax = 0;
			swapIndex = 0;
			swapSamples = 0;
			lastPresentAt = 0;
			presentErr = 0;
			bodyEst = 3000000.0;
			bodyIndex = 0;
			bodyCount = 0;
			gpuMargin = DEFAULT_GPU_MARGIN_NS;
			baseMargin = DEFAULT_GPU_MARGIN_NS;
			frameBase = 0;
			swapInterval = 0;
			lastSwapCheckNs = 0;
			lastTarget = 0;
			pacedLogged = false;
			lastStartNs = 0;
			lastGlContext = nullptr;
			// legacy variable name: this now disables the whole pacer, anchor included
			pacerOff = getenv ("LIME_NO_SCANLINE_GATE") != nullptr;
			logEnabled = false;

			if (const char* logSwitch = getenv ("LIME_FRAMEPACER_LOG")) {

				logEnabled = strcmp (logSwitch, "1") == 0;

			}
			presentPhasePct = PRESENT_PHASE_PCT_DEFAULT;

			if (const char* phase = getenv ("LIME_PRESENT_PHASE_PCT")) {

				long long parsed = atoll (phase);

				if (parsed >= 0) presentPhasePct = (Uint64) parsed;

				if (presentPhasePct > 50) presentPhasePct = 50;

			}
			scanAdapter = 0;
			scanSource = 0;
			beamStartLine = 0;
			beamStartBlank = false;
			beamEndLine = 0;
			beamEndBlank = false;
			beamValid = false;
			beamEndValid = false;
			gpuQueryInit = false;
			gpuQueryActive = false;
			gpuQueryIndex = 0;
			gpuSamples = 0;
			gpuBody = 0.0;
			gpuRef = 0.0;

			swapCount = 0;
			tearCount = 0;
			lateCount = 0;
			errSum = 0;
			errMin = 0;
			errMax = 0;
			ivIndex = 0;
			ivCount = 0;
			statWindow = 0;


			HMODULE gdi = GetModuleHandleW (L"gdi32.dll");

			if (gdi) {

				openAdapter = (FP_OpenAdapterFromLuidFunc) GetProcAddress (gdi, "D3DKMTOpenAdapterFromLuid");
				closeAdapter = (FP_CloseAdapterFunc) GetProcAddress (gdi, "D3DKMTCloseAdapter");
				waitVBlank = (FP_WaitForVerticalBlankEventFunc) GetProcAddress (gdi, "D3DKMTWaitForVerticalBlankEvent");
				getScanLine = (FP_GetScanLineFunc) GetProcAddress (gdi, "D3DKMTGetScanLine");

			}

			HMODULE dwm = LoadLibraryW (L"dwmapi.dll");

			if (dwm) {

				dwmTiming = (FP_DwmGetCompositionTimingInfoFunc) GetProcAddress (dwm, "DwmGetCompositionTimingInfo");

			}

			// resolve up front: the dump runs while the main thread is stuck
			HMODULE dbghelp = LoadLibraryW (L"dbghelp.dll");

			if (dbghelp) {

				dumpWriter = (FP_MiniDumpWriteDumpFunc) GetProcAddress (dbghelp, "MiniDumpWriteDump");

			}

			LARGE_INTEGER freq;

			if (QueryPerformanceFrequency (&freq)) {

				qpcFreq = (Uint64) freq.QuadPart;

			}

			for (int i = 0; i < 3; i++) gpuQueries[i] = 0;

			for (int i = 0; i < 32; i++) swapRing[i] = 0;

			for (int i = 0; i < 64; i++) bodyRing[i] = 0;

			for (int i = 0; i < 256; i++) ivRing[i] = 0;

		}


		~FramePacerImpl () {

			if (anchorThread) {

				delete anchorThread;

			}

			if (watchdogThread) {

				delete watchdogThread;

			}

			if (mainThread) {

				CloseHandle (mainThread);

			}

		}


		void CloseCurrentAdapter () {

			scanAdapter = 0;

			if (adapterOpen && closeAdapter) {

				FP_CloseAdapter ca;
				ca.hAdapter = hAdapter;
				closeAdapter (&ca);

			}

			adapterOpen = false;
			hAdapter = 0;

		}


		void OnWindowSet (SDL_Window* window) {

			if (sdlWindow) return;

			sdlWindow = window;

			SDL_PropertiesID props = SDL_GetWindowProperties (sdlWindow);
			hwndValue = (HWND) SDL_GetPointerProperty (props, SDL_PROP_WINDOW_WIN32_HWND_POINTER, nullptr);

			if (!running) {

				running = true;

				if (!pacerOff) {

					anchorThread = new std::thread (AnchorLoopStatic, this);

				}

				watchdogThread = new std::thread (WatchdogLoopStatic, this);

				GateLogRaw ("[FramePacer] hang watchdog armed\n");

			}

		}


		// only the bound window is gated; other windows swap straight through
		bool IsBoundWindow (SDL_Window* window) {

			return sdlWindow && window == sdlWindow;

		}


		bool IsGated () {

			return gateActive;

		}


		// monitor/frequency via Win32/CCD, not SDL's tracking -- same path the
		// anchor uses, so pacing and anchor can never bind different displays
		bool RefreshDisplayTarget () {

			if (!sdlWindow) return false;

			HMONITOR monitor = MonitorFromWindow (hwndValue, MONITOR_DEFAULTTONEAREST);

			if (!monitor) return false;

			MONITORINFOEXW mi;

			mi.cbSize = sizeof (MONITORINFOEXW);

			if (!GetMonitorInfoW (monitor, (LPMONITORINFO) &mi)) return false;

			DEVMODEW dm;

			dm.dmSize = sizeof (DEVMODEW);

			if (!EnumDisplaySettingsW (mi.szDevice, ENUM_CURRENT_SETTINGS, &dm)) return false;

			if (!(dm.dmFields & DM_DISPLAYFREQUENCY) || dm.dmDisplayFrequency < 20 || dm.dmDisplayFrequency > 1000) return false;

			// DWM timing only describes the primary display
			POINT origin = { 0, 0 };
			HMONITOR primary = MonitorFromPoint (origin, MONITOR_DEFAULTTOPRIMARY);

			useDwm = primary && monitor == primary;

			// g-sync wobble must not wipe the period override; only a display move does
			if (monitor != lastMonitor) {

				periodOverride = 0;

			}

			lastMonitor = monitor;
			lastRefreshRate = dm.dmDisplayFrequency;
			periodNs = (Uint64) std::llround (1e9 / (double) dm.dmDisplayFrequency);
			requestGen++;
			displayBound = true;

			ResetPacing ();

			char logBuf[192];

			snprintf (logBuf, sizeof (logBuf), "[FramePacer] display bound: %ls freq=%lu Hz dwm=%d\n",
				mi.szDevice, (unsigned long) dm.dmDisplayFrequency, useDwm.load () ? 1 : 0);
			GateLogRaw (logBuf);

			return true;

		}


		// Reopen the anchor when the window moves to another display or the mode changes
		void CheckDisplay () {

			if (!sdlWindow) return;

			// a dead HWND resolves monitors against an empty rect forever
			if (!IsWindow (hwndValue)) {

				SDL_PropertiesID props = SDL_GetWindowProperties (sdlWindow);
				HWND fresh = (HWND) SDL_GetPointerProperty (props, SDL_PROP_WINDOW_WIN32_HWND_POINTER, nullptr);

				if (fresh && fresh != hwndValue) {

					hwndValue = fresh;
					lastMonitor = nullptr;
					RefreshDisplayTarget ();
					return;

				}

			}

			// anchor/CCD disagree: one side bound the wrong display (throttled)
			if (rebindHint.exchange (false)) {

				Uint64 now = SDL_GetTicksNS ();

				if (!lastRebindNs || now - lastRebindNs > 1000000000ULL) {

					lastRebindNs = now;
					lastMonitor = nullptr;
					RefreshDisplayTarget ();

				}

				return;

			}

			HMONITOR monitor = MonitorFromWindow (hwndValue, MONITOR_DEFAULTTONEAREST);

			if (monitor != lastMonitor) {

				RefreshDisplayTarget ();
				return;

			}

			// detect driver-panel mode changes via CCD; with a period override active, wobble is noise
			if (lastRefreshRate && !periodOverride.load ()) {

				MONITORINFOEXW mi;

				mi.cbSize = sizeof (MONITORINFOEXW);

				if (GetMonitorInfoW (monitor, (LPMONITORINFO) &mi)) {

					DEVMODEW dm;

					dm.dmSize = sizeof (DEVMODEW);

					if (EnumDisplaySettingsW (mi.szDevice, ENUM_CURRENT_SETTINGS, &dm)
						&& (dm.dmFields & DM_DISPLAYFREQUENCY)
						&& dm.dmDisplayFrequency != lastRefreshRate) {

						RefreshDisplayTarget ();

					}

				}

			}

		}


		// Resolve the window's monitor to (adapter, VidPnSourceId) and open it
		bool RequeryTarget () {

			CloseCurrentAdapter ();

			if (!openAdapter || !hwndValue) return false;

			HMONITOR monitor = MonitorFromWindow (hwndValue, MONITOR_DEFAULTTONEAREST);

			if (!monitor) return false;

			MONITORINFOEXW mi;

			mi.cbSize = sizeof (MONITORINFOEXW);

			if (!GetMonitorInfoW (monitor, (LPMONITORINFO) &mi)) return false;

			UINT32 pathCount = 0, modeCount = 0;

			if (GetDisplayConfigBufferSizes (QDC_ONLY_ACTIVE_PATHS, &pathCount, &modeCount) != ERROR_SUCCESS) return false;

			std::vector<DISPLAYCONFIG_PATH_INFO> paths (pathCount);
			std::vector<DISPLAYCONFIG_MODE_INFO> modes (modeCount);

			if (QueryDisplayConfig (QDC_ONLY_ACTIVE_PATHS, &pathCount, paths.data (), &modeCount, modes.data (), nullptr) != ERROR_SUCCESS) return false;

			for (UINT32 i = 0; i < pathCount; i++) {

				DISPLAYCONFIG_SOURCE_DEVICE_NAME sourceName;

				sourceName.header.type = DISPLAYCONFIG_DEVICE_INFO_GET_SOURCE_NAME;
				sourceName.header.size = sizeof (DISPLAYCONFIG_SOURCE_DEVICE_NAME);
				sourceName.header.adapterId = paths[i].sourceInfo.adapterId;
				sourceName.header.id = paths[i].sourceInfo.id;

				if (DisplayConfigGetDeviceInfo (&sourceName.header) != ERROR_SUCCESS) continue;

				if (wcscmp (sourceName.viewGdiDeviceName, mi.szDevice) == 0) {

					FP_OpenAdapterFromLuid oa;

					oa.AdapterLuid = paths[i].sourceInfo.adapterId;

					if (openAdapter (&oa) >= 0) {

						hAdapter = oa.hAdapter;
						vidPnSourceId = paths[i].sourceInfo.id;
						adapterOpen = true;
						scanAdapter = hAdapter;
						scanSource = vidPnSourceId;
						lastVbForPeriod = 0;
						failStreak = 0;
						lastDwmNs = 0;
						dwmGap = 0;

						// stale interval would trip the divergence check
						realPeriod = 0;
						divergeCount = 0;
						divergeRound = 0;

						char logBuf[128];

						snprintf (logBuf, sizeof (logBuf),
							"[FramePacer] anchor ready: %ls VidPn=%u\n",
							mi.szDevice, (unsigned) vidPnSourceId);
						GateLogRaw (logBuf);

						return true;

					}

					return false;

				}

			}

			return false;

		}


		Uint64 QpcToNs (Uint64 ticks) {

			if (!qpcFreq) return 0;

			return (Uint64) ((double) ticks * 1000000000.0 / (double) qpcFreq);

		}


		// Waits real vblank interrupts and publishes a predicted edge clock
		void AnchorLoop () {

			while (running) {

				// wait for the first stable binding or the anchor latches the birth screen
				if (!displayBound.load ()) {

					for (int i = 0; i < 20 && running; i++) SDL_DelayNS (50000000ULL);
					continue;

				}

				Uint32 req = requestGen;

				if (req != appliedLocal || !adapterOpen) {

					if (RequeryTarget ()) {

						appliedLocal = req;

					} else {

						LogState ("anchor requery failed");

						for (int i = 0; i < 100 && running; i++) SDL_DelayNS (50000000ULL);
						continue;

					}

				}

				FP_WaitForVerticalBlankEvent wait;

				wait.hAdapter = hAdapter;
				wait.hDevice = 0;
				wait.VidPnSourceId = vidPnSourceId;

				NTSTATUS status = waitVBlank (&wait);

				if (status < 0) {

					if (++failStreak >= 8) {

						CloseCurrentAdapter ();

						for (int i = 0; i < 20 && running; i++) SDL_DelayNS (50000000ULL);

					}

					continue;

				}

				failStreak = 0;

				Uint64 now = SDL_GetTicksNS ();

				vbAlive = now;

				// Smooth the measured interval, rejecting outliers (VRR, wakeups)
				if (lastVbForPeriod) {

					Uint64 delta = now - lastVbForPeriod;

					if (delta > 100000ULL && delta < 200000000ULL) {

						Uint64 current = realPeriod.load ();

						if (!current) {

							realPeriod = delta;

						} else if (std::llabs ((long long) delta - (long long) current) < (long long) (current / 4)) {

							// signed math: unsigned underflowed and stuck realPeriod at ~2^61 ns
							realPeriod = (Uint64) ((long long) current + ((long long) delta - (long long) current) / 8);

						}

					}

				}

				lastVbForPeriod = now;

				Uint64 measured = realPeriod.load ();
				Uint64 basePeriod = measured ? measured : periodNs;

				// PLL on wake times: the absolute phase is late by the wake latency,
				// the jitter is what the filter is for
				if (basePeriod) {

					Uint64 pred = predEdge.load ();

					if (!pred) {

						pred = now;

					} else {

						pred += basePeriod;

						long long err = (long long) now - (long long) pred;

						pred = (Uint64) ((long long) pred + err / 8);

					}

					predEdge = pred;

				}

				// DWM's vblank stamp is not the scanout edge, only its exact period is kept
				if (now - lastDwmNs > 1000000000ULL) {

					lastDwmNs = now;

					if (useDwm.load () && dwmTiming && qpcFreq) {

						LARGE_INTEGER qpcAtNow;

						QueryPerformanceCounter (&qpcAtNow);

						DWM_TIMING_INFO ti;

						memset (&ti, 0, sizeof (ti));
						ti.cbSize = (UINT) sizeof (ti);

						if (dwmTiming (nullptr, &ti) == S_OK) {

							if (ti.qpcRefreshPeriod) {

								Uint64 hp = QpcToNs ((Uint64) ti.qpcRefreshPeriod);

								if (hp && (!periodNs || (hp > periodNs / 2 && hp < periodNs * 2))) {

									anchorPeriod = hp;

								}

							}

							if (ti.qpcVBlank) {

								long long delta = (long long) qpcAtNow.QuadPart - (long long) ti.qpcVBlank;
								long long age = delta < 0
									? -(long long) QpcToNs ((Uint64) (-delta))
									: (long long) QpcToNs ((Uint64) delta);

								dwmGap = (long long) predEdge.load () - ((long long) now - age);

							}

						}

					}

				}

				// persistent measured-vs-CCD mismatch = wrong display binding
				Uint64 base = periodNs;
				Uint64 smoothed = realPeriod.load ();

				if (base >= 1000000ULL && smoothed) {

					if (smoothed < base / 4 * 3 || smoothed > base / 4 * 5) {

						if (++divergeCount >= 4) {

							divergeCount = 0;

							// round 2+: rebind hints loop forever (g-sync) -- trust the hardware value
							if (++divergeRound == 1) {

								rebindHint = true;

								char dBuf[128];

								snprintf (dBuf, sizeof (dBuf),
									"[FramePacer] diverge: meas=%.2f ms ccd=%.2f ms\n",
									smoothed / 1e6, base / 1e6);
								GateLogRaw (dBuf);

							} else if (divergeRound == 2) {

								periodOverride = smoothed;

								char oBuf[128];

								snprintf (oBuf, sizeof (oBuf),
									"[FramePacer] period override: using measured %.2f ms\n",
									smoothed / 1e6);
								GateLogRaw (oBuf);

							} else {

								periodOverride = smoothed;

							}

						}

					} else {

						divergeCount = 0;

						if (divergeRound) divergeRound = 0;

					}

				}

			}

		}


		static void AnchorLoopStatic (FramePacerImpl* pacer) {

			// anchor timestamps feed every phase calculation -- keep this thread fast
			SetThreadPriority (GetCurrentThread (), THREAD_PRIORITY_TIME_CRITICAL);

			pacer->AnchorLoop ();

		}


		// The main thread never blocks for seconds on purpose; if it does, the
		// process is hung. Dump it once so the stack survives the kill.
		static void WatchdogLoopStatic (FramePacerImpl* pacer) {

			SetThreadPriority (GetCurrentThread (), THREAD_PRIORITY_LOWEST);

			pacer->WatchdogLoop ();

		}


		void WatchdogLoop () {

			while (running) {

				for (int i = 0; i < 20 && running; i++) SDL_DelayNS (50000000ULL);

				if (!running) break;

				Uint64 beat = heartbeat.load ();

				if (!beat) continue;

				Uint64 stalled = SDL_GetTicksNS () - beat;

				if (stalled < 8000000000ULL) continue;

				// a suspended machine is not a hang
				if (hwndValue && !IsHungAppWindow (hwndValue)) continue;

				LogStall ("main thread stalled", stalled);
				LogMainThreadRip ();

				if (!hangDumped.exchange (true)) WriteHangDump ();

			}

		}


		void WriteHangDump () {

			if (!dumpWriter) return;

			HANDLE file = CreateFileW (L"framepacer-hang.dmp", GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);

			if (file == INVALID_HANDLE_VALUE) return;

			// thread info only: small, and every stack is still there
			dumpWriter (GetCurrentProcess (), GetCurrentProcessId (), file, 0x1000, nullptr, nullptr, nullptr);

			CloseHandle (file);

			GateLogRaw ("[FramePacer] hang dump written: framepacer-hang.dmp\n");

		}


		// one RIP sample is enough to tell a driver wait from a pacer wait
		void LogMainThreadRip () {

			if (!mainThread) return;

			if (SuspendThread (mainThread) == (DWORD) -1) return;

			CONTEXT ctx;
			memset (&ctx, 0, sizeof (ctx));
			ctx.ContextFlags = CONTEXT_CONTROL;

			if (GetThreadContext (mainThread, &ctx)) {

				MEMORY_BASIC_INFORMATION mbi;

				if (VirtualQuery ((LPCVOID) ctx.Rip, &mbi, sizeof (mbi)) && mbi.AllocationBase) {

					wchar_t path[MAX_PATH];

					if (GetModuleFileNameW ((HMODULE) mbi.AllocationBase, path, MAX_PATH)) {

						const wchar_t* name = path;
						const wchar_t* slash = nullptr;

						for (const wchar_t* c = path; *c; c++) {

							if (*c == L'\\') slash = c;

						}

						if (slash) name = slash + 1;

						char narrow[128];

						if (WideCharToMultiByte (CP_UTF8, 0, name, -1, narrow, sizeof (narrow), nullptr, nullptr)) {

							char buf[192];

							snprintf (buf, sizeof (buf), "[FramePacer] main thread blocked in %s+0x%llx (phase=%d)\n",
								narrow, (unsigned long long) (ctx.Rip - (DWORD64) mbi.AllocationBase), stallPhase.load ());
							GateLogRaw (buf);

						}

					}

				}

			}

			ResumeThread (mainThread);

		}


		void LogStall (const char* event, Uint64 value) {

			Uint64 now = SDL_GetTicksNS ();
			Uint64 last = lastStallLog.load ();

			if (last && now - last < 1000000000ULL) return;

			lastStallLog = now;

			char buf[192];

			snprintf (buf, sizeof (buf), "[FramePacer] %s: %.1f ms phase=%d\n",
				event, (double) value / 1e6, stallPhase.load ());

			GateLogRaw (buf);

		}


		void OnSwapBegin () {

			if (gateActive) stallPhase = 3;

		}


		// Measured period when sane, SDL display mode value otherwise
		Uint64 EffectivePeriod () {

			Uint64 override = periodOverride.load ();

			if (override >= 1000000ULL && override <= 100000000ULL) return override;

			Uint64 p = realPeriod.load ();
			Uint64 base = periodNs;

			if (base < 1000000ULL) return 0;

			if (p < base * 7 / 10 || p > base * 13 / 10) p = base;

			return p;

		}


		// DWM's period is exact; the measured one is only used as a fallback
		Uint64 PacingPeriod () {

			Uint64 override = periodOverride.load ();

			if (override >= 1000000ULL && override <= 100000000ULL) return override;

			Uint64 p = EffectivePeriod ();

			Uint64 hp = anchorPeriod.load ();

			if (hp && (!periodNs || (hp > periodNs * 9 / 10 && hp < periodNs * 11 / 10))) p = hp;

			return p;

		}


		// First edge strictly after t, computed from the anchor's last edge
		Uint64 NextEdgeAfter (Uint64 t, Uint64 period, Uint64 base) {

			if (!period || !base) return 0;

			Uint64 e = base;

			if (t > base) e = base + ((t - base) / period) * period;

			if (e <= t) e += period;

			return e;

		}


		// cadence state is per-display; must not survive a monitor switch
		void ResetPacing () {

			gateActive = false;
			framePeriod = 0;
			frameEps = 0;
			targetEdge = 0;
			nextTarget = 0;
			gridStep = 1;
			frameStartT0 = 0;
			readyAt = 0;
			presentAt = 0;
			lastPresentAt = 0;
			presentErr = 0;
			bodyEst = 3000000.0;
			bodyIndex = 0;
			bodyCount = 0;
			frameBase = 0;
			pacedLogged = false;
			gpuBody = 0.0;
			gpuRef = 0.0;
			gpuSamples = 0;
			gpuMargin = baseMargin;

			swapStartAt = 0;
			swapEndAt = 0;
			swapLead = 300000ULL;
			swapP95 = 0;
			swapMax = 0;
			swapIndex = 0;
			swapSamples = 0;

			swapCount = 0;
			tearCount = 0;
			lateCount = 0;
			errSum = 0;
			errMin = 0;
			errMax = 0;
			ivIndex = 0;
			ivCount = 0;
			statWindow = 0;

		}


		// stderr/OutputDebugString are invisible for a GUI app -- log to file too
		void GateLogRaw (const char* text) {

			if (!logEnabled) return;

			static std::mutex logMutex;
			std::lock_guard<std::mutex> lock (logMutex);

			// oversized so the ~350-char state line keeps its newline
			char stamped[640];

			snprintf (stamped, sizeof (stamped), "[%llu ms] %s",
				(unsigned long long) (SDL_GetTicksNS () / 1000000ULL), text);

			OutputDebugStringA (stamped);
			fprintf (stderr, "%s", stamped);

			static FILE* logFile = nullptr;

			if (!logFile) {

				logFile = fopen ("framepacer.log", "a");

			}

			if (logFile) {

				fputs (stamped, logFile);
				fflush (logFile);

			}

		}


		void LogState (const char* event) {

			char buf[160];

			Uint64 now = SDL_GetTicksNS ();
			Uint64 alive = vbAlive.load ();
			bool fresh = alive && now - alive <= ANCHOR_STALE_NS;

			snprintf (buf, sizeof (buf), "[FramePacer] %s | anchor=%s P=%.3f ms\n",
				event, fresh ? "live" : "stale", EffectivePeriod () / 1e6);

			GateLogRaw (buf);

		}


		void LogPaced () {

			if (pacedLogged) return;

			pacedLogged = true;

			char buf[224];

			snprintf (buf, sizeof (buf),
				"[FramePacer] paced: anchor=pll P=%.3f ms eps=%.3f ms swap=%.3f ms margin=%.3f ms step=%d\n",
				framePeriod / 1e6,
				frameEps / 1e6,
				swapLead / 1e6,
				gpuMargin / 1e6,
				gridStep);

			GateLogRaw (buf);

		}


		// log on state change or every 10 s; intervals, not swap counts, are the evidence
		void LogStateHeartbeat () {

			if (!logEnabled) return;

			Uint64 now = SDL_GetTicksNS ();

			if (!statWindow) {

				statWindow = now;
				return;

			}

			if (now - statWindow < STAT_WINDOW_NS) return;

			double secs = (double) (now - statWindow) / 1e9;
			double fps = secs > 0.0 ? (double) swapCount / secs : 0.0;
			double avgErr = swapCount ? (double) errSum / (double) swapCount / 1e6 : 0.0;

			double tgt = lastTarget ? 1e9 / (double) lastTarget : 0.0;

			Uint32 p50 = 0, p99 = 0, ivMax = 0;

			if (ivCount) {

				Uint32 tmp[256];

				for (Uint32 i = 0; i < ivCount; i++) tmp[i] = ivRing[i];

				for (Uint32 i = 1; i < ivCount; i++) {

					Uint32 v = tmp[i];
					Uint32 j = i;

					while (j > 0 && tmp[j - 1] > v) {

						tmp[j] = tmp[j - 1];
						j--;

					}

					tmp[j] = v;

				}

				p50 = tmp[ivCount / 2];
				p99 = tmp[(Uint32) ((double) (ivCount - 1) * 0.99)];
				ivMax = tmp[ivCount - 1];

			}

			char beam[40];

			if (beamValid) {

				if (beamEndValid) {

					snprintf (beam, sizeof (beam), "%u%c/%u%c",
						beamStartLine, beamStartBlank ? 'v' : 'a',
						beamEndLine, beamEndBlank ? 'v' : 'a');

				} else {

					snprintf (beam, sizeof (beam), "%u%c/?", beamStartLine, beamStartBlank ? 'v' : 'a');

				}

			} else {

				snprintf (beam, sizeof (beam), "na");

			}

			char buf[640];

			// frame start to the target edge: input age bound for this frame
			Uint64 lat = (gateActive && targetEdge > frameStartT0) ? targetEdge - frameStartT0 : 0;

			snprintf (buf, sizeof (buf),
				"[FramePacer] state | fs=%d mode=%d lock=%d tgt=%.0f step=%d gap=%.2f beam=%s P=%.3f eps=%.3f body=%.2f margin=%.2f gpu=%.2f swap=%.2f sw=%.2f/%.2f pad=%.2f/%.2f lat=%.2f | fps=%.1f swaps=%u tear=%u late=%u err avg=%.2f min=%.2f max=%.2f | iv50=%.2f iv99=%.2f ivmax=%.2f\n",
				fullscreenMode ? 1 : 0,
				mode.load (),
				prevLockMode ? 1 : 0,
				tgt,
				gridStep,
				(double) dwmGap.load () / 1e6,
				beam,
				framePeriod / 1e6,
				frameEps / 1e6,
				bodyEst / 1e6,
				gpuMargin / 1e6,
				gpuBody / 1e6,
				swapLead / 1e6,
				(double) swapP95 / 1e6,
				(double) swapMax / 1e6,
				(double) startWait.pad / 1e6,
				(double) swapWait.pad / 1e6,
				(double) lat / 1e6,
				fps,
				swapCount,
				tearCount,
				lateCount,
				avgErr,
				errMin / 1e6,
				errMax / 1e6,
				p50 / 1e6,
				p99 / 1e6,
				ivMax / 1e6);

			GateLogRaw (buf);

			swapCount = 0;
			tearCount = 0;
			lateCount = 0;
			errSum = 0;
			errMin = 0;
			errMax = 0;
			ivIndex = 0;
			ivCount = 0;
			swapMax = 0;
			statWindow = now;

		}


		bool GLReady () {

			void* ctx = (void*) SDL_GL_GetCurrentContext ();

			// a recreated context invalidates every query name; never reuse them
			if (ctx != lastGlContext) {

				lastGlContext = ctx;
				gpuQueryInit = false;
				gpuQueryActive = false;
				gpuQueries[0] = 0;
				gpuQueries[1] = 0;
				gpuQueries[2] = 0;

			}

			return ctx != nullptr;

		}


		// GL_TIME_ELAPSED spans the frame on the GPU clock; the 1-2 frame
		// delayed result is a slow drift reference, never a blocking read
		void UpdateGpuBody (Uint64 ns) {

			if (ns < 100000ULL || ns > 50000000ULL) return;

			gpuBody = gpuBody > 0.0 ? gpuBody * 7.0 / 8.0 + (double) ns / 8.0 : (double) ns;

			if (gpuSamples < 32) {

				if (++gpuSamples == 32) gpuRef = gpuBody;
				return;

			}

			if (!gpuRef) return;

			double delta = gpuBody - gpuRef;

			if (delta > 4000000.0) delta = 4000000.0;
			if (delta < -4000000.0) delta = -4000000.0;

			double target = (double) baseMargin + delta;

			if (target < 150000.0) target = 150000.0;
			if (target > 8000000.0) target = 8000000.0;

			// windowed: the GPU tail lands after the CPU body; keep a fraction of
			// the GPU time as tail allowance instead of only tracking its delta
			if (!fullscreenMode) {

				double floor = gpuBody * 0.25;

				if (floor < 400000.0) floor = 400000.0;
				if (target < floor) target = floor;

			} else {

				// fullscreen: the flip latches at GPU finish, so the margin covers the whole tail
				double floor = gpuBody - (double) swapLead;

				if (floor < 400000.0) floor = 400000.0;
				if (target < floor) target = floor;

			}

			double step = target - (double) gpuMargin;

			// scene spikes jump the margin straight to the new target
			if (step > 200000.0) {

				gpuMargin = (Uint64) target;
				return;

			}

			if (step > 10000.0) step = 10000.0;
			if (step < -10000.0) step = -10000.0;

			gpuMargin = (Uint64) ((double) gpuMargin + step);

		}


		void BeginGpuQuery () {

			if (!GLReady ()) return;

			if (!gpuQueryInit) {

				glGenQueries (3, gpuQueries);
				gpuQueryInit = true;

			}

			if (gpuQueryActive) {

				glEndQuery (GL_TIME_ELAPSED);
				gpuQueryActive = false;

			}

			GLuint q = gpuQueries[gpuQueryIndex];
			GLuint avail = 0;

			glGetQueryObjectuiv (q, GL_QUERY_RESULT_AVAILABLE, &avail);

			if (avail) {

				GLuint64 ns = 0;

				glGetQueryObjectui64v (q, GL_QUERY_RESULT, &ns);
				UpdateGpuBody ((Uint64) ns);

			}

			glBeginQuery (GL_TIME_ELAPSED, q);
			gpuQueryActive = true;
			gpuQueryIndex = (gpuQueryIndex + 1) % 3;

		}


		void EndGpuQuery () {

			if (!gpuQueryActive) return;

			if (!GLReady ()) return;

			// GLReady drops the query when the context changed underneath us
			if (!gpuQueryActive) return;

			glEndQuery (GL_TIME_ELAPSED);
			gpuQueryActive = false;

		}


		Uint64 PresentPhase (Uint64 period) const {

			if (!fullscreenMode || !presentPhasePct || !period) return 0;

			Uint64 phase = period * presentPhasePct / 100;

			return phase < period / 2 ? phase : period / 2;

		}


		bool WaitFrameStart (Uint64 target) {

			lastTarget = target;

			Uint64 now = SDL_GetTicksNS ();

			heartbeat = now;

			// kill switch for A/B: the whole pacer (anchor included) stays off
			if (pacerOff) {

				gateActive = false;

				return false;

			}

			bool fs = sdlWindow && (SDL_GetWindowFlags (sdlWindow) & SDL_WINDOW_FULLSCREEN) != 0;

			if (fs != prevFullscreenMode) {

				prevFullscreenMode = fs;
				ResetPacing ();

			}

			fullscreenMode = fs;

			int requested = mode.load ();

			if (requested < 0) requested = 1;

			bool lock = requested == 2;

			if (lock != prevLockMode) {

				prevLockMode = lock;
				ResetPacing ();

			}

			// a load or GC stall must not inherit the old grid: start right away
			// and re-anchor on the next frame
			Uint64 gap = lastStartNs ? now - lastStartNs : 0;

			lastStartNs = now;

			if (gap > 50000000ULL) {

				if (gap > 200000000ULL) LogStall ("long frame gap", gap);

				nextTarget = 0;
				gateActive = false;
				frameStartT0 = now;
				swapEndAt = 0;
				stallPhase = 0;

				return true;

			}

			LogStateHeartbeat ();

			// pacer disabled at runtime: the plain frame-rate wait owns the cap
			if (requested == 0) {

				gateActive = false;
				nextTarget = 0;

				return false;

			}

			// 3 s poll once bound, 100 ms retry while unbound
			Uint64 checkNs = lastMonitor ? 3000000000ULL : 100000000ULL;

			if (!lastCheckNs || rebindHint.load () || now - lastCheckNs >= checkNs) {

				lastCheckNs = now;
				CheckDisplay ();

			}

			gateActive = false;

			if (!sdlWindow || !openAdapter || !waitVBlank) return false;

			Uint64 alive = vbAlive.load ();

			if (!alive || now - alive > ANCHOR_STALE_NS) return false;

			// no cap and not locked: there is no grid to lock onto, so skip the rest
			if (!lock && target == 0) {

				framePeriod = PacingPeriod ();
				frameEps = 0;
				gridStep = 1;

				return false;

			}

			// never pace on top of vsync; the WGL query is cached and re-read once
			// per second (RefreshSwapInterval invalidates it)
			if (!lastSwapCheckNs || now - lastSwapCheckNs >= 1000000000ULL) {

				lastSwapCheckNs = now;
				int interval = 0;

				if (!SDL_GL_GetSwapInterval (&interval)) interval = 0;

				swapInterval = interval;

			}

			if (swapInterval != 0) return false;

			Uint64 period = PacingPeriod ();

			if (!period) return false;

			// cap below the refresh rate: present every whole number of refreshes
			int step = 1;

			if (target != 0) {

				double ratio = (double) target / (double) period;

				step = (int) std::llround (ratio);

				if (step < 1) step = 1;
				if (step > 8) step = 8;

			}

			// adaptive: only whole-refresh caps can lock to the composition grid
			if (!lock && std::fabs ((double) target - (double) step * (double) period) > (double) period / 32.0) {

				framePeriod = period;
				frameEps = 0;
				gridStep = 1;

				return false;

			}

			Uint64 base = predEdge.load ();

			if (!base) return false;

			// D3DKMT wakes after the edge; shift the predicted clock by the mean wake
			if (base > PLL_BIAS_NS) base -= PLL_BIAS_NS;

			gridStep = step;
			framePeriod = period;
			frameBase = base;

			Uint64 grid = period * (Uint64) step;
			Uint64 edge;

			Uint64 phase = PresentPhase (period);

			if (!nextTarget || nextTarget <= now) {

				edge = NextEdgeAfter (now, grid, base);

				if (edge) edge += phase;

			} else {

				edge = nextTarget;

			}

			if (!edge) return false;

			targetEdge = edge;

			Uint64 eps;

			if (!fullscreenMode) {

				eps = WINDOWED_EPS_NS;

				// keep at least half a refresh for the frame body
				if (eps > period / 2) eps = period / 2;

			} else {

				eps = PLL_EPS_NS;

				// body over one grid: the extra lead is the overlap the next frame
				// needs to start before this frame's GPU tail finishes
				double over = bodyEst + 100000.0 - (double) grid;

				if (over > 0.0) {

					Uint64 autoEps = (Uint64) over;

					if (autoEps > eps) eps = autoEps;

				}

			}

			// above the windowed eps, so its compose deadline stays reachable
			if (eps > 6000000ULL) eps = 6000000ULL;

			frameEps = eps;

			// the swap itself is a submit latency the body estimate cannot see:
			// it blocks when the flip queue is full, so carry it in the lead too
			Uint64 swapPad = swapLead;
			Uint64 lead = (Uint64) bodyEst + eps + swapPad;

			if (lead < 300000ULL) lead = 300000ULL;
			if (lead > grid + eps + swapPad) lead = grid + eps + swapPad;

			// start early enough for the body to end eps before the edge; never
			// start before the previous present, that would be two frames in flight
			Uint64 start = (edge > lead) ? edge - lead : 0;

			if (start < lastPresentAt) start = lastPresentAt;
			if (start < now) start = now;

			if (start > now) {

				Uint64 wait = start - now;
				Uint64 horizon = grid + period;

				// stale grid or bad anchor data: never hold the main thread on it
				if (wait > horizon) {

					LogStall ("frame start wait too far", wait);

					nextTarget = 0;
					gateActive = false;
					frameStartT0 = now;

					return true;

				}

				stallPhase = 1;
				heartbeat = SDL_GetTicksNS ();

				FrameWaitUntil (startWait, start);

				stallPhase = 0;

			}

			frameStartT0 = SDL_GetTicksNS ();
			gateActive = true;
			swapEndAt = 0;
			heartbeat = frameStartT0;
			stallPhase = 0;

			BeginGpuQuery ();

			LogPaced ();

			return true;

		}


		// windowed swap blocks on the driver/DWM copy; P95 keeps the lead honest
		// without paying for the rare multi-ms spike every frame
		void UpdateSwapLead (Uint64 swap) {

			if (swap > swapMax) swapMax = swap;

			// a non-blocking swap reads 0; multi-ms spikes are dropped from the p95
			if (swap > 4000000ULL) return;

			swapRing[swapIndex] = swap;
			swapIndex = (swapIndex + 1) & 31;

			if (swapSamples < 32) swapSamples++;

			Uint64 tmp[32];

			for (int i = 0; i < swapSamples; i++) tmp[i] = swapRing[i];

			for (int i = 1; i < swapSamples; i++) {

				Uint64 v = tmp[i];
				int j = i - 1;

				while (j >= 0 && tmp[j] > v) {

					tmp[j + 1] = tmp[j];
					j--;

				}

				tmp[j + 1] = v;

			}

			int idx = swapSamples * 95 / 100;

			if (idx >= swapSamples) idx = swapSamples - 1;
			if (idx < 0) idx = 0;

			swapP95 = tmp[idx];
			swapLead = swapP95 + 100000ULL;

			if (swapLead < 100000ULL) swapLead = 100000ULL;

			// the submit can outlast 1.5 ms; 3 ms keeps the lead inside a 5 ms refresh
			if (swapLead > 3000000ULL) swapLead = 3000000ULL;

		}


		void RecordPresent (Uint64 t) {

			// lastPresentAt clamps the next frame start; the interval ring is log-only
			if (logEnabled && lastPresentAt) {

				Uint64 iv = t - lastPresentAt;

				if (iv > 0 && iv < 1000000000ULL) {

					ivRing[ivIndex] = (Uint32) iv;
					ivIndex = (ivIndex + 1) & 255;

					if (ivCount < 256) ivCount++;

				}

			}

			lastPresentAt = t;

		}


		// raster read for the present probe: false when the query is unavailable
		bool GetBeam (UINT* line, bool* blank) {

			D3DKMT_HANDLE adapter = scanAdapter.load ();

			if (!getScanLine || !adapter) return false;

			FP_GetScanLine g;

			g.hAdapter = adapter;
			g.VidPnSourceId = scanSource.load ();
			g.InVerticalBlank = 0;
			g.ScanLine = 0;

			if (getScanLine (&g) < 0) return false;

			if (line) *line = g.ScanLine;
			if (blank) *blank = g.InVerticalBlank != 0;

			return true;

		}


		// blocks until the present deadline; the swap always runs
		void WaitSwap () {

			if (!gateActive) {

				// unpaced: keep lastPresentAt fresh, counters are log-only
				RecordPresent (SDL_GetTicksNS ());

				if (logEnabled) swapCount++;

				return;

			}

			EndGpuQuery ();

			// the swap has to start early enough that the blocking submit lands
			// eps before the edge
			Uint64 back = frameEps + swapLead;
			Uint64 deadline = (targetEdge > back) ? targetEdge - back : 0;

			readyAt = SDL_GetTicksNS ();

			if (readyAt < deadline) {

				Uint64 wait = deadline - readyAt;
				Uint64 horizon = framePeriod * (Uint64) gridStep + framePeriod;

				// never park the main thread on a stale target
				if (wait > horizon) {

					LogStall ("swap deadline too far", wait);

				} else {

					stallPhase = 2;
					heartbeat = readyAt;

					FrameWaitUntil (swapWait, deadline);

					stallPhase = 0;

				}

			}

			if (logEnabled && readyAt > deadline) lateCount++;

			// the beam probe only feeds the state line, so it is log-only
			if (logEnabled) beamValid = GetBeam (&beamStartLine, &beamStartBlank);

			swapStartAt = SDL_GetTicksNS ();
			heartbeat = swapStartAt;

		}


		// called right after SDL_GL_SwapWindow; the time spent there is the real
		// submit latency, not the frame body's
		void OnSwapEnd (Uint64 now) {

			stallPhase = 0;
			heartbeat = now;

			if (!gateActive || !swapStartAt) return;

			if (now <= swapStartAt || now - swapStartAt >= 20000000ULL) return;

			swapEndAt = now;

			if (logEnabled) beamEndValid = GetBeam (&beamEndLine, &beamEndBlank);

			UpdateSwapLead (now - swapStartAt);

		}



		double BodyPercentile (double p) {

			if (!bodyCount) return 0.0;

			Uint64 tmp[64];

			for (int i = 0; i < bodyCount; i++) tmp[i] = bodyRing[i];

			for (int i = 1; i < bodyCount; i++) {

				Uint64 v = tmp[i];
				int j = i - 1;

				while (j >= 0 && tmp[j] > v) {

					tmp[j + 1] = tmp[j];
					j--;

				}

				tmp[j + 1] = v;

			}

			int idx = (int) (p * (double) (bodyCount - 1) + 0.5);

			if (idx < 0) idx = 0;
			if (idx >= bodyCount) idx = bodyCount - 1;

			return (double) tmp[idx];

		}


		void OnFrameEnd (Uint64 frameEnd) {

			heartbeat = frameEnd;
			stallPhase = 0;

			if (!gateActive || !readyAt || readyAt < frameStartT0) return;

			Uint64 cpu = readyAt - frameStartT0;

			bodyRing[bodyIndex] = cpu;
			bodyIndex = (bodyIndex + 1) & 63;

			if (bodyCount < 64) bodyCount++;

			bodyEst = BodyPercentile (fullscreenMode ? 0.90 : 0.95) + (double) gpuMargin;

			if (framePeriod) {

				double cap = (double) framePeriod * (double) gridStep + 3000000.0;

				if (bodyEst > cap) bodyEst = cap;

			}

			if (bodyEst < 300000.0) bodyEst = 300000.0;

			// ContextFlip reports the swap end; fall back to the frame timestamp for
			// paths that do not call it
			Uint64 present = swapEndAt;

			if (!present && frameEnd > swapStartAt && frameEnd - swapStartAt < 20000000ULL) {

				present = frameEnd;

				UpdateSwapLead (frameEnd - swapStartAt);

			}

			presentAt = present ? present : frameEnd;
			presentErr = (long long) presentAt - (long long) targetEdge;

			RecordPresent (presentAt);

			// stat counters are log-only, presentErr stays live (it re-anchors the grid)
			if (logEnabled) {

				if (presentErr > 0) tearCount++;

				errSum += presentErr;

				if (swapCount == 0) {

					errMin = presentErr;
					errMax = presentErr;

				} else {

					if (presentErr < errMin) errMin = presentErr;
					if (presentErr > errMax) errMax = presentErr;

				}

				swapCount++;

			}

			// one present per grid point: the next target is the one after this
			// edge, and a late frame re-anchors on the edge after the present
			Uint64 grid = framePeriod * (Uint64) gridStep;

			if (grid) {

				if (presentErr <= 0) nextTarget = targetEdge + grid;
				else {

					Uint64 t = NextEdgeAfter (presentAt, grid, frameBase);
					nextTarget = t + PresentPhase (framePeriod);

				}

			} else {

				nextTarget = 0;

			}

		}

	};


	FramePacer::FramePacer () {

		impl = nullptr;
		mode = -1;

	}


	FramePacer::~FramePacer () {

		if (impl) {

			FramePacerImpl* pacer = (FramePacerImpl*) impl;

			pacer->running = false;

			if (pacer->anchorThread && pacer->anchorThread->joinable ()) {

				pacer->anchorThread->join ();

			}

			if (pacer->watchdogThread && pacer->watchdogThread->joinable ()) {

				pacer->watchdogThread->join ();

			}

			pacer->CloseCurrentAdapter ();
			delete pacer;

			impl = nullptr;

		}

	}


	void FramePacer::SetWindow (SDL_Window* sdlWindow) {

		if (!impl) {

			FramePacerImpl* pacer = new FramePacerImpl ();

			if (!pacer->openAdapter || !pacer->closeAdapter || !pacer->waitVBlank) {

				delete pacer;
				return;

			}

			impl = pacer;

		}

		((FramePacerImpl*) impl)->mode = mode;

		((FramePacerImpl*) impl)->OnWindowSet (sdlWindow);

	}


	void FramePacer::SetMode (int mode) {

		if (mode < -1 || mode > 2) mode = -1;

		this->mode = mode;

		if (impl) {

			((FramePacerImpl*) impl)->mode = mode;

		}

	}


	void FramePacer::RefreshSwapInterval () {

		if (impl) ((FramePacerImpl*) impl)->lastSwapCheckNs = 0;

	}


	bool FramePacer::WaitFrameStart (Uint64 target) {

		if (!impl) return false;

		return ((FramePacerImpl*) impl)->WaitFrameStart (target);

	}


	void FramePacer::WaitSwap () {

		if (impl) ((FramePacerImpl*) impl)->WaitSwap ();

	}


	bool FramePacer::IsBoundWindow (SDL_Window* window) {

		if (!impl) return false;

		return ((FramePacerImpl*) impl)->IsBoundWindow (window);

	}


	bool FramePacer::IsGated () {

		if (!impl) return false;

		return ((FramePacerImpl*) impl)->IsGated ();

	}


	void FramePacer::OnSwapBegin () {

		if (impl) ((FramePacerImpl*) impl)->OnSwapBegin ();

	}


	void FramePacer::OnSwapEnd (Uint64 now) {

		if (impl) ((FramePacerImpl*) impl)->OnSwapEnd (now);

	}



	void FramePacer::OnFrameEnd (Uint64 frameEnd) {

		if (impl) ((FramePacerImpl*) impl)->OnFrameEnd (frameEnd);

	}


}


#else // HX_WINDOWS


namespace lime {


	FramePacer::FramePacer () {

		impl = nullptr;
		mode = -1;

	}


	FramePacer::~FramePacer () {


	}


	void FramePacer::SetWindow (SDL_Window* sdlWindow) {


	}


	void FramePacer::SetMode (int mode) {


	}


	void FramePacer::RefreshSwapInterval () {


	}


	bool FramePacer::WaitFrameStart (Uint64 target) {

		return false;

	}


	void FramePacer::WaitSwap () {


	}


	bool FramePacer::IsBoundWindow (SDL_Window* window) {

		return false;

	}


	bool FramePacer::IsGated () {

		return false;

	}


	void FramePacer::OnSwapBegin () {


	}


	void FramePacer::OnSwapEnd (Uint64 now) {


	}



	void FramePacer::OnFrameEnd (Uint64 frameEnd) {


	}


}


#endif // HX_WINDOWS
