#ifndef LIME_SDL_FRAME_PACER_H
#define LIME_SDL_FRAME_PACER_H


#include <SDL3/SDL.h>


namespace lime {


	// SDL sleeps wake late by a jittery amount: cut the sleep short by the recent
	// lateness and spin the rest, so the spin stays bounded
	static const Uint64 FRAME_WAIT_PAD_WINDOW_NS = 2000000000ULL;
	static const Uint64 FRAME_WAIT_PAD_DEFAULT_NS = 1000000ULL;
	// later than this is preemption, not timer lateness
	static const Uint64 FRAME_WAIT_PAD_MAX_NS = 4000000ULL;


	struct FrameWaitState {

		Uint64 pad;      // current sleep cut-short amount
		Uint64 sample;   // max overshoot recorded in this window
		Uint64 window;   // window start clock

		FrameWaitState () {

			pad = FRAME_WAIT_PAD_DEFAULT_NS;
			sample = 0;
			window = 0;

		}

	};


	inline void FrameWaitUntil (FrameWaitState& state, Uint64 deadline) {

		Uint64 now = SDL_GetTicksNS ();

		if (now >= deadline) return;

		if (!state.window) {

			state.window = now;

		} else if (now - state.window >= FRAME_WAIT_PAD_WINDOW_NS) {

			// window max replaces the pad, so a one-off spike cannot stick
			if (state.sample) state.pad = state.sample;

			state.sample = 0;
			state.window = now;

		}

		Uint64 wait = deadline - now;
		Uint64 pad = state.pad < wait ? state.pad : wait;

		if (wait > pad) {

			Uint64 sleepNs = wait - pad;
			Uint64 target = now + sleepNs;

			SDL_DelayNS (sleepNs);

			Uint64 over = SDL_GetTicksNS ();
			over = over > target ? over - target : 0;

			if (over <= FRAME_WAIT_PAD_MAX_NS) {

				if (over > state.sample) state.sample = over;

				if (over > state.pad) state.pad = over;

			}

		}

		while (SDL_GetTicksNS () < deadline) {

		}

	}


	class FramePacer {

		public:

			FramePacer ();
			~FramePacer ();

			void SetWindow (SDL_Window* sdlWindow);

			void SetMode (int mode);

			// vsync changed: re-read the swap interval on the next frame
			void RefreshSwapInterval ();

			bool WaitFrameStart (Uint64 target);

			// hold the swap until the present deadline; bound window only
			void WaitSwap ();

			bool IsBoundWindow (SDL_Window* window);

			// true when WaitFrameStart held this frame
			bool IsGated ();

			void OnSwapBegin ();

			void OnSwapEnd (Uint64 now);

			void OnFrameEnd (Uint64 frameEnd);

		private:

			void* impl;
			int mode;

	};


}


#endif // LIME_SDL_FRAME_PACER_H
