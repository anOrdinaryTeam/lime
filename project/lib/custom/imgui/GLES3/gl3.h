#pragma once

// Dear ImGui's OpenGL3 backend includes <GLES3/gl3.h> when built with
// IMGUI_IMPL_OPENGL_ES3. On GLES targets lime already loads every GLES 3.2
// entry point through glad (OpenGLBindings::Init -> gladLoadGLES2), so route
// the backend through the same function pointers instead of linking the
// system libGLESv2.
#include <glad/gles2.h>
