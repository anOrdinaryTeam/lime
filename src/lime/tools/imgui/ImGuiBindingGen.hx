package lime.tools.imgui;

using StringTools;

class ImGuiBindingGen {

    //not perfect but works for what I need
    //will remove this later

    public static function generateBindings() {
        var defs = "";

		var generateGetSet = false;
		var staticFunc = true;
		var needsHandle = false;
		var handleClass = "ImDrawList";
		var handleVar = "drawList";

		var bindingPrefix = "lime_imgui";
		var hxFuncInnerTop = "\n\t#if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)";
		var hxFuncInnerBot = "\n\t#end";
		var cppFuncInnerTop = "\n\t#ifdef LIME_IMGUI";
		var cppFuncInnerBot = "\n\t#endif";
		var cppCall = "ImGui::";

		if (needsHandle) {
			hxFuncInnerTop += "\n\tif (!isValid()) return 0;";
			cppFuncInnerTop += "\n\t" + handleClass + "* "+handleVar+" = ("+handleClass+"*)getPointerFromHandle(handle);";
			cppCall = handleVar+"->";
		}

		var hxPrefix = generateGetSet ? "private" : "public";
		hxPrefix += staticFunc ? " static function" : " function";

		var hxFuncTemplate = hxPrefix + " #hxFunc(#hxArgs):#hxReturnType\n {#funcInnerTop\n\t#returnFuncNativeCFFI.#bindingFunc(#hxArgsInput);#funcInnerBot#returnDefault\n}";		
		var cffiFuncTemplate = 'private static var #bindingFunc = new cpp.Callable<#cffiArgLink>(cpp.Prime._loadPrime("lime", "#bindingFunc", "#cffiArgIds", false));';
		var cppFuncTemplate = "#cppReturnType #bindingFunc(#cppArgs){#funcInnerTop\n\t#returnFunc#cppCall#func(#cppArgsInput);#funcInnerBot#returnDefault\n}";
		var primeTemplate = "DEFINE_PRIME#argCount#isVoid (#bindingFunc);";

		hxFuncTemplate = hxFuncTemplate.replace("#funcInnerTop", hxFuncInnerTop);
		hxFuncTemplate = hxFuncTemplate.replace("#funcInnerBot", hxFuncInnerBot);
		cppFuncTemplate = cppFuncTemplate.replace("#funcInnerTop", cppFuncInnerTop);
		cppFuncTemplate = cppFuncTemplate.replace("#funcInnerBot", cppFuncInnerBot);
		cppFuncTemplate = cppFuncTemplate.replace("#cppCall", cppCall);

		var hxSetFuncTemplate = hxPrefix + " set_#hxFunc(#hxArgs):#hxReturnType\n {#funcInnerTop\n\t#returnFuncNativeCFFI.#bindingFunc(#hxArgsInput);#funcInnerBot#returnDefault\n}";
		var hxGetFuncTemplate = hxPrefix + " get_#hxFunc():#hxReturnType\n {#funcInnerTop\n\t#returnFuncNativeCFFI.#bindingFunc(#hxArgsInput);#funcInnerBot#returnDefault\n}";
		hxSetFuncTemplate = hxSetFuncTemplate.replace("#funcInnerTop", hxFuncInnerTop);
		hxSetFuncTemplate = hxSetFuncTemplate.replace("#funcInnerBot", hxFuncInnerBot);
		hxGetFuncTemplate = hxGetFuncTemplate.replace("#funcInnerTop", hxFuncInnerTop);
		hxGetFuncTemplate = hxGetFuncTemplate.replace("#funcInnerBot", hxFuncInnerBot);

		var cppGetFuncTemplate = "#cppReturnType #bindingFunc(#cppArgs){#funcInnerTop\n\t#returnFunc#cppCall#func;#funcInnerBot#returnDefault\n}";
		var cppSetFuncTemplate = "#cppReturnType #bindingFunc(#cppArgs){#funcInnerTop\n\t#returnFunc#cppCall#func = #cppArgsInput;#funcInnerBot#returnDefault\n}";
		cppSetFuncTemplate = cppSetFuncTemplate.replace("#funcInnerTop", cppFuncInnerTop);
		cppSetFuncTemplate = cppSetFuncTemplate.replace("#funcInnerBot", cppFuncInnerBot);
		cppSetFuncTemplate = cppSetFuncTemplate.replace("#cppCall", cppCall);
		cppGetFuncTemplate = cppGetFuncTemplate.replace("#funcInnerTop", cppFuncInnerTop);
		cppGetFuncTemplate = cppGetFuncTemplate.replace("#funcInnerBot", cppFuncInnerBot);
		cppGetFuncTemplate = cppGetFuncTemplate.replace("#cppCall", cppCall);

		var hxFuncs:String = "";
		var cffiFuncs:String = "";
		var cppFuncs:String = "";
		var primeFuncs:String = "";
		var getSetVarDefs:String = "";


		var formattedStr = "";
		for (i in 0...defs.length) {
			var char = defs.charAt(i);
			if (i > 0) {
				var lastChar = defs.charAt(i-1);
				if (char == " " && lastChar == " ") {

				} else {
					formattedStr += char;
				}
			} else {
				formattedStr += char;
			}
		}
		formattedStr = formattedStr.replace("	", "");

		var parseState:Int = 0;
		var lines = formattedStr.split(";");

		var data:Array<Dynamic> = [];

		for (l in lines) {
			var line = l.trim();
			if (line == "") continue;
			if (line.contains("//")) continue;
			

			var funcData:Dynamic = {
				funcName: "",
				returnType: "",
				argTypes: [],
				argNames: [],
				set: true,
				isVec2: false
			};

			if (!generateGetSet) {
				var spaceSplit = line.split(" ");
				funcData.returnType = spaceSplit[1];
				funcData.funcName = spaceSplit[2].substring(0, spaceSplit[2].indexOf("("));

				var argsStart = line.indexOf("(")+1;
				var argsEnd = line.lastIndexOf(")");
				var argsList = line.substring(argsStart, argsEnd);
				//clear out default arg values
				while(true) {
					if (argsList.indexOf("=") != -1) {
						var eIndex = argsList.indexOf("=");
						if (argsList.indexOf("=", eIndex+1) == -1) {
							argsList = argsList.substring(0, eIndex);
						} else {
							var commaIndex = argsList.indexOf(",", eIndex);
							var bIndex = argsList.indexOf(")");
							if (bIndex != -1) {
								commaIndex = argsList.indexOf(",", bIndex);
							}
							var p1 = argsList.substring(0, eIndex-1);
							var p2 = argsList.substr(commaIndex);
							argsList = p1 + p2;
						}
					} else {
						break;
					}
				}

				var args = argsList.split(",");
				for (arg in args) {
					var trimmed = arg.trim();
					if (trimmed == "") continue;
					var split = trimmed.split(" ");
					var varName = split[split.length-1];
					var typeName = split[split.length-2];
					funcData.argTypes.push(typeName);
					funcData.argNames.push(varName);
				}
				
				if (needsHandle) {
					funcData.argTypes.insert(0, "double");
					funcData.argNames.insert(0, "handle");
				}

				trace(funcData.returnType, funcData.funcName, funcData.argTypes, funcData.argNames);
				data.push(funcData);
			} else {
				var spaceSplit = line.split(" ");

				var varName = spaceSplit[spaceSplit.length-1];
				var typeName = spaceSplit[spaceSplit.length-2];

				var isVec2 = typeName == "ImVec2";
				if (isVec2) {
					typeName = "float";
					varName += "X";
				}

				funcData.returnType = typeName;
				funcData.funcName = varName;
				funcData.argTypes = [typeName];
				funcData.argNames = [varName];

				var funcData2:Dynamic = {
					funcName: varName,
					returnType: typeName,
					argTypes: [],
					argNames: [],
					set: false,
					isVec2: false
				};

				if (needsHandle) {
					funcData.argTypes.insert(0, "double");
					funcData.argNames.insert(0, "handle");
					funcData2.argTypes.insert(0, "double");
					funcData2.argNames.insert(0, "handle");
				}

				if (isVec2) {
					funcData.isVec2 = true;
					funcData2.isVec2 = true;
				}

				trace(funcData.returnType, funcData.funcName, funcData.argTypes, funcData.argNames);
				data.push(funcData2);
				data.push(funcData);

				if (isVec2) {
					var varNameY = spaceSplit[spaceSplit.length-1] + "Y";
					var funcData3:Dynamic = {
						funcName: varNameY,
						returnType: typeName,
						argTypes: [typeName],
						argNames: [varNameY],
						set: true,
						isVec2: true
					};
					var funcData4:Dynamic = {
						funcName: varNameY,
						returnType: typeName,
						argTypes: [],
						argNames: [],
						set: false,
						isVec2: true
					};
					if (needsHandle) {
						funcData3.argTypes.insert(0, "double");
						funcData3.argNames.insert(0, "handle");
						funcData4.argTypes.insert(0, "double");
						funcData4.argNames.insert(0, "handle");
					}
					data.push(funcData4);
					data.push(funcData3);
				}
			}
		}

		function getCppArgType(argType:String) {
			switch(argType) {
				case "void": return "void";
				case "bool": return "bool";
				case "int": return "int";
				case "float": return "float";
				case "double": return "double";
				case "char*": return "HxString";
				case "ImVec4" | "ImVec4&": return "int";
				case "ImTextureRef": return "int";
				case "ImGuiID" | "ImGuiCond" | "ImWchar" | "ImGuiDir" | "ImGuiKey" | "ImGuiKeyChord" | "ImGuiMouseButton" | "ImGuiMouseCursor": return "int";
				case "ImFont*" | "ImFontGlyph*" | "ImGuiTableSortSpecs*": return "double";
			}
			if (argType.toLowerCase().contains("flags")) return "int";
			return "value";
		}
		function getHxArgType(argType:String) {
			switch(argType) {
				case "void": return "Void";
				case "bool": return "Bool";
				case "int": return "Int";
				case "float": return "Float";
				case "double": return "Float";
				case "char*": return "String";
				case "ImVec4" | "ImVec4&" | "ImWchar" | "ImGuiDir": return "Int";
				case "ImTextureRef": return "ImTextureID";
				case "bool*": return "ImGuiBoolPtr";
				case "float*": return "ImGuiFloatPtr";
				case "int*": return "ImGuiIntPtr";
			}
			return argType;
		}
		function getCffiArgType(argType:String, returnType:Bool) {
			switch(argType) {
				case "void": return returnType ? "cpp.Void" : "Void";
				case "bool": return "Bool";
				case "int": return "Int";
				case "float": return "Float32";
				case "double": return "Float";
				case "char*": return "String";
				case "ImVec4" | "ImVec4&" | "ImWchar" | "ImGuiDir" | "ImGuiKey" | "ImGuiKeyChord" | "ImGuiMouseButton" | "ImGuiMouseCursor": return "Int";
				case "ImTextureRef": return "Int";
				case "ImGuiID" | "ImGuiCond": return "Int";
				case "ImFont*" | "ImFontGlyph*" | "ImGuiTableSortSpecs*": return "Float";
			}
			if (argType.toLowerCase().contains("flags")) return "Int";
			return "cpp.Object";
		}
		function getCffiArgID(argType:String, returnType:Bool) {
			switch(argType) {
				case "void": return returnType ? "v" : "";
				case "bool": return "b";
				case "int": return "i";
				case "float": return "f";
				case "double": return "d";
				case "char*": return "s";
				case "ImVec4" | "ImVec4&" | "ImWchar" | "ImGuiDir" | "ImGuiKey" | "ImGuiKeyChord" | "ImGuiMouseButton" | "ImGuiMouseCursor": return "i";
				case "ImTextureRef": return "i";
				case "ImGuiID" | "ImGuiCond": return "i";
				case "ImFont*" | "ImFontGlyph*" | "ImGuiTableSortSpecs*": return "d";
			}
			if (argType.toLowerCase().contains("flags")) return "i";
			return "o";
		}
		
		//trace("\n" + hxFuncTemplate + "\n" + cffiFuncTemplate + "\n" + cppFuncTemplate);
		for (func in data) {
			var bindingFuncName = bindingPrefix;
			if (generateGetSet) bindingFuncName += (func.set ? "_set" : "_get");
			var hxFuncName = "";
			for (i in 0...func.funcName.length) {
				var char:String = func.funcName.charAt(i);
				if (char == char.toUpperCase()) bindingFuncName += "_";
				bindingFuncName += char.toLowerCase();

				if (i == 0) {
					hxFuncName += char.toLowerCase();
				} else {
					hxFuncName += char;
				}
			}

			var hxArgs = "";
			var hxArgsInput = "";
			var cppArgs = "";
			var cppArgsInput = "";
			var cffiArgLink = "";
			var cffiArgIds = "";

			var argCount = 0;
			for (i in 0...func.argTypes.length) {
				var t = func.argTypes[i];
				var n = func.argNames[i];
				var addComma = i < func.argTypes.length-1;
				var isVec2 = t == "ImVec2" || t == "ImVec2&";
				if (isVec2 && !generateGetSet) {
					t = "float";
					n += "X";
				}

				if (!(needsHandle && n == "handle")) {
					hxArgs += n + ":" + getHxArgType(t);
					if (isVec2 && !generateGetSet) hxArgs += ", " + func.argNames[i] + "Y" + ":" + getHxArgType(t);
					if (addComma) hxArgs += ", ";
				}

				hxArgsInput += n;
				if (isVec2 && !generateGetSet) hxArgsInput += ", " + func.argNames[i] + "Y";
				if (addComma) hxArgsInput += ", ";

				
				cppArgs += getCppArgType(t) + " " + n;
				if (isVec2 && !generateGetSet) cppArgs += ", " + getCppArgType(t) + " " + func.argNames[i] + "Y";
				if (addComma) cppArgs += ", ";

				if (!(needsHandle && n == "handle")) {
					if (isVec2 && !generateGetSet) {
						cppArgsInput += "ImVec2(" + n + ", " + func.argNames[i] + "Y)";
					} else {
						cppArgsInput += n + (t == "char*" ? ".__s" : "");
					}
					if (addComma) cppArgsInput += ", ";
				}

				cffiArgLink += getCffiArgType(t, false) + "->";
				if (isVec2 && !generateGetSet) cffiArgLink += getCffiArgType(t, false) + "->";

				cffiArgIds += getCffiArgID(t, false);
				if (isVec2 && !generateGetSet) cffiArgIds += getCffiArgID(t, false);

				argCount++;
				if (isVec2 && !generateGetSet) argCount++;
			}
			if (argCount == 0) {
				cffiArgLink += "Void->";
			}
			cffiArgLink += getCffiArgType(func.returnType, true);
			cffiArgIds += getCffiArgID(func.returnType, true);
			//trace("\n" + hxArgs + "\n" + hxArgsInput + "\n" + cppArgs + "\n" + cppArgsInput + "\n" + cffiArgLink + "\n" + cffiArgIds);

			if (!generateGetSet) {
				var hxFuncFull = hxFuncTemplate;
				hxFuncFull = hxFuncFull.replace("#hxFunc", hxFuncName);
				hxFuncFull = hxFuncFull.replace("#hxArgsInput", hxArgsInput);
				hxFuncFull = hxFuncFull.replace("#hxArgs", hxArgs);
				hxFuncFull = hxFuncFull.replace("#hxReturnType", getHxArgType(func.returnType));
				hxFuncFull = hxFuncFull.replace("#bindingFunc", bindingFuncName);
				hxFuncFull = hxFuncFull.replace("#returnFunc", func.returnType == "void" ? "" : "return ");
				hxFuncFull = hxFuncFull.replace("#returnDefault", func.returnType == "void" ? "" : "\n\treturn " + (func.returnType == "bool" ? "false;" : "0;"));
				hxFuncs += hxFuncFull + "\n\n";

				var cffiFuncFull = cffiFuncTemplate.replace("#bindingFunc", bindingFuncName);
				cffiFuncFull = cffiFuncFull.replace("#cffiArgLink", cffiArgLink);
				cffiFuncFull = cffiFuncFull.replace("#cffiArgIds", cffiArgIds);
				cffiFuncs += cffiFuncFull + "\n";

				var primeFuncFull = primeTemplate.replace("#bindingFunc", bindingFuncName);
				primeFuncFull = primeFuncFull.replace("#argCount", argCount + "");
				primeFuncFull = primeFuncFull.replace("#isVoid", func.returnType == "void" ? "v" : "");
				primeFuncs += primeFuncFull + "\n";

				var cppFuncFull = cppFuncTemplate.replace("#bindingFunc", bindingFuncName);
				cppFuncFull = cppFuncFull.replace("#cppReturnType", getCppArgType(func.returnType));
				cppFuncFull = cppFuncFull.replace("#cppArgsInput", cppArgsInput);
				cppFuncFull = cppFuncFull.replace("#cppArgs", cppArgs);
				cppFuncFull = cppFuncFull.replace("#func", func.funcName);
				cppFuncFull = cppFuncFull.replace("#returnFunc", func.returnType == "void" ? "" : "return ");
				cppFuncFull = cppFuncFull.replace("#returnDefault", func.returnType == "void" ? "" : "\n\treturn " + (func.returnType == "bool" ? "false;" : "0;"));
				cppFuncs += cppFuncFull + "\n";
			} else {
				if (!func.set) {
					var prefix = staticFunc ? "public static var " : "public var ";
					var varName = "";
					for (i in 0...func.funcName.length) {
						var char:String = func.funcName.charAt(i);
						if (i == 0) {
							varName += char.toLowerCase();
						} else {
							varName += char;
						}
					}
					prefix += varName + "(get, set):" + getHxArgType(func.returnType) + ";";
					getSetVarDefs += prefix + "\n";
				}
				var hxFuncFull = func.set ? hxSetFuncTemplate : hxGetFuncTemplate;
				hxFuncFull = hxFuncFull.replace("#hxFunc", hxFuncName);
				hxFuncFull = hxFuncFull.replace("#hxArgsInput", hxArgsInput);
				hxFuncFull = hxFuncFull.replace("#hxArgs", hxArgs);
				hxFuncFull = hxFuncFull.replace("#hxReturnType", getHxArgType(func.returnType));
				hxFuncFull = hxFuncFull.replace("#bindingFunc", bindingFuncName);
				hxFuncFull = hxFuncFull.replace("#returnFunc", "return ");
				hxFuncFull = hxFuncFull.replace("#returnDefault", "\n\treturn " + (func.returnType == "bool" ? "false;" : "0;"));
				hxFuncs += hxFuncFull + "\n";

				var cffiFuncFull = cffiFuncTemplate.replace("#bindingFunc", bindingFuncName);
				cffiFuncFull = cffiFuncFull.replace("#cffiArgLink", cffiArgLink);
				cffiFuncFull = cffiFuncFull.replace("#cffiArgIds", cffiArgIds);
				cffiFuncs += cffiFuncFull + "\n";

				var primeFuncFull = primeTemplate.replace("#bindingFunc", bindingFuncName);
				primeFuncFull = primeFuncFull.replace("#argCount", argCount + "");
				primeFuncFull = primeFuncFull.replace("#isVoid", func.returnType == "void" ? "v" : "");
				primeFuncs += primeFuncFull + "\n";

				var cppFuncName = func.funcName;
				if (func.isVec2) {
					var last = cppFuncName.charAt(cppFuncName.length-1);
					cppFuncName = cppFuncName.substring(0, cppFuncName.length-1) + "." + last.toLowerCase();
				}

				var cppFuncFull = func.set ? cppSetFuncTemplate : cppGetFuncTemplate;
				cppFuncFull = cppFuncFull.replace("#bindingFunc", bindingFuncName);
				cppFuncFull = cppFuncFull.replace("#cppReturnType", getCppArgType(func.returnType));
				cppFuncFull = cppFuncFull.replace("#cppArgsInput", cppArgsInput);
				cppFuncFull = cppFuncFull.replace("#cppArgs", cppArgs);
				cppFuncFull = cppFuncFull.replace("#func", cppFuncName);
				cppFuncFull = cppFuncFull.replace("#returnFunc", func.returnType == "void" ? "" : "return ");
				cppFuncFull = cppFuncFull.replace("#returnDefault", func.returnType == "void" ? "" : "\n\treturn " + (func.returnType == "bool" ? "false;" : "0;"));
				cppFuncs += cppFuncFull + "\n";
			}


		}

		//trace("\nCPP:\n" + cppFuncs /* + "\nCPP Primes: \n" + primeFuncs + "\nCFFI: \n" + cffiFuncs + "\nHX: \n" + hxFuncs + "\n"*/);
		if (generateGetSet) {
			trace("\nCPP:\n" + cppFuncs + "\nCPP Primes: \n" + primeFuncs + "\nCFFI: \n" + cffiFuncs + "\nHX Vars: \n" + getSetVarDefs + "\nHX: \n" + hxFuncs + "\n");
		} else {
			trace("\nCPP:\n" + cppFuncs + "\nCPP Primes: \n" + primeFuncs + "\nCFFI: \n" + cffiFuncs + "\nHX: \n" + hxFuncs + "\n");
		}
    }
}