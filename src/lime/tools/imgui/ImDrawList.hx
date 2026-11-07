package lime.tools.imgui;

import lime.tools.imgui.ImGuiPtr;
import lime.tools.imgui.ImGuiFlags;
import lime.tools.imgui.ImGuiTypes;
import lime._internal.backend.native.NativeCFFI;

@:access(lime._internal.backend.native.NativeCFFI)
class ImDrawList extends ImGuiTempPtrHandle
{
    public function pushClipRect(clip_rect_minX:Float, clip_rect_minY:Float, clip_rect_maxX:Float, clip_rect_maxY:Float, intersect_with_current_clip_rect:Bool = false):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_push_clip_rect(handle, clip_rect_minX, clip_rect_minY, clip_rect_maxX, clip_rect_maxY, intersect_with_current_clip_rect);
        #end
    }

    public function pushClipRectFullScreen():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_push_clip_rect_full_screen(handle);
        #end
    }

    public function popClipRect():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_pop_clip_rect(handle);
        #end
    }

    public function pushTexture(tex_ref:ImTextureID):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_push_texture(handle, tex_ref);
        #end
    }

    public function popTexture():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_pop_texture(handle);
        #end
    }

    public function getClipRectMin():ImVec2
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return null;
        var vec:Dynamic = NativeCFFI.lime_imgui_draw_list_get_clip_rect_min(handle);
		return new ImVec2(vec.x, vec.y);
        #end
        return null;
    }

    public function getClipRectMax():ImVec2
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return null;
        var vec:Dynamic = NativeCFFI.lime_imgui_draw_list_get_clip_rect_max(handle);
		return new ImVec2(vec.x, vec.y);
        #end
        return null;
    }

    public function addLine(points:Array<Float>, col:ImColor, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_line(handle, points, col, thickness);
        #end
    }

    public function addLineH(min_x:Float, max_x:Float, y:Float, col:ImColor, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_line_h(handle, min_x, max_x, y, col, thickness);
        #end
    }

    public function addLineV(x:Float, min_y:Float, max_y:Float, col:ImColor, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_line_v(handle, x, min_y, max_y, col, thickness);
        #end
    }

    public function addRect(points:Array<Float>, col:ImColor, rounding:Float = 0.0, thickness:Float = 1.0, flags:ImDrawFlags = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_rect(handle, points, col, rounding, thickness, flags);
        #end
    }

    public function addRectFilled(points:Array<Float>, col:ImColor, rounding:Float = 0.0, flags:ImDrawFlags = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_rect_filled(handle, points, col, rounding, flags);
        #end
    }

    public function addRectFilledMultiColor(points:Array<Float>, col_upr_left:ImColor, col_upr_right:ImColor, col_bot_right:ImColor, col_bot_left:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        col_upr_left = ((col_upr_left.a & 0xFF) << 24) | ((col_upr_left.b & 0xFF) << 16) | ((col_upr_left.g & 0xFF) << 8) | (col_upr_left.r & 0xFF);
        col_upr_right = ((col_upr_right.a & 0xFF) << 24) | ((col_upr_right.b & 0xFF) << 16) | ((col_upr_right.g & 0xFF) << 8) | (col_upr_right.r & 0xFF);
        col_bot_right = ((col_bot_right.a & 0xFF) << 24) | ((col_bot_right.b & 0xFF) << 16) | ((col_bot_right.g & 0xFF) << 8) | (col_bot_right.r & 0xFF);
        col_bot_left = ((col_bot_left.a & 0xFF) << 24) | ((col_bot_left.b & 0xFF) << 16) | ((col_bot_left.g & 0xFF) << 8) | (col_bot_left.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_rect_filled_multi_color(handle, points, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
        #end
    }

    public function addQuad(points:Array<Float>, col:ImColor, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 8) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_quad(handle, points, col, thickness);
        #end
    }

    public function addQuadFilled(points:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 8) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_quad_filled(handle, points, col);
        #end
    }

    public function addTriangle(points:Array<Float>, col:ImColor, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 6) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_triangle(handle, points, col, thickness);
        #end
    }

    public function addTriangleFilled(points:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 6) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_triangle_filled(handle, points, col);
        #end
    }

    public function addCircle(centerX:Float, centerY:Float, radius:Float, col:ImColor, num_segments:Int = 0, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_circle(handle, centerX, centerY, radius, col, num_segments, thickness);
        #end
    }

    public function addCircleFilled(centerX:Float, centerY:Float, radius:Float, col:ImColor, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_circle_filled(handle, centerX, centerY, radius, col, num_segments);
        #end
    }

    public function addNgon(centerX:Float, centerY:Float, radius:Float, col:ImColor, num_segments:Int, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_ngon(handle, centerX, centerY, radius, col, num_segments, thickness);
        #end
    }

    public function addNgonFilled(centerX:Float, centerY:Float, radius:Float, col:ImColor, num_segments:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_ngon_filled(handle, centerX, centerY, radius, col, num_segments);
        #end
    }

    public function addEllipse(centerX:Float, centerY:Float, radiusX:Float, radiusY:Float, col:ImColor, rot:Float = 0.0, num_segments:Int = 0, thickness:Float = 1.0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_ellipse(handle, centerX, centerY, radiusX, radiusY, col, rot, num_segments, thickness);
        #end
    }

    public function addEllipseFilled(centerX:Float, centerY:Float, radiusX:Float, radiusY:Float, col:ImColor, rot:Float = 0.0, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_ellipse_filled(handle, centerX, centerY, radiusX, radiusY, col, rot, num_segments);
        #end
    }

    public function addText(posX:Float, posY:Float, col:ImColor, text_begin:String, text_end:String = null):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_text(handle, posX, posY, col, text_begin, text_end);
        #end
    }

    /*public function addText(font:ImFont, font_size:Float, posX:Float, posY:Float, col:ImColor, text_begin:String, text_end:String, wrap_width:Float, cpu_fine_clip_rect:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_add_text(handle, font, font_size, posX, posY, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect);
        #end
    }*/

    public function addBezierCubic(points:Array<Float>, col:ImColor, thickness:Float, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 8) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_bezier_cubic(handle, points, col, thickness, num_segments);
        #end
    }

    public function addBezierQuadratic(points:Array<Float>, col:ImColor, thickness:Float, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 6) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_bezier_quadratic(handle, points, col, thickness, num_segments);
        #end
    }

    public function addPolyline(points:Array<Float>, col:ImColor, thickness:Float, flags:ImDrawFlags = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length == 0 || points.length % 2 != 0) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_polyline(handle, points, Std.int(points.length/2), col, thickness, flags);
        #end
    }

    public function addConvexPolyFilled(points:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length == 0 || points.length % 2 != 0) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_convex_poly_filled(handle, points, Std.int(points.length/2), col);
        #end
    }

    public function addConcavePolyFilled(points:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length == 0 || points.length % 2 != 0) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_concave_poly_filled(handle, points, Std.int(points.length/2), col);
        #end
    }

    public function addImage(tex_ref:ImTextureID, points:Array<Float>, ?uvPoints:Array<Float> = null, col:ImColor = 0xFFFFFFFF):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        if (uvPoints == null) uvPoints = [0,0,1,1];
        if (uvPoints.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_image(handle, tex_ref, points, uvPoints, col);
        #end
    }

    public function addImageQuad(tex_ref:ImTextureID, points:Array<Float>, ?uvPoints:Array<Float> = null, col:ImColor = 0xFFFFFFFF):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 8) return;
        if (uvPoints == null) uvPoints = [0,0,1,0,1,1,0,1];
        if (uvPoints.length < 8) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_image_quad(handle, tex_ref, points, uvPoints, col);
        #end
    }

    public function addImageRounded(tex_ref:ImTextureID, points:Array<Float>, uvPoints:Array<Float>, col:ImColor, rounding:Float, flags:ImDrawFlags = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        if (uvPoints == null || uvPoints.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_add_image_rounded(handle, tex_ref, points, uvPoints, col, rounding, flags);
        #end
    }

    public function pathClear():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_clear(handle);
        #end
    }

    public function pathLineTo(posX:Float, posY:Float):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_line_to(handle, posX, posY);
        #end
    }

    public function pathLineToMergeDuplicate(posX:Float, posY:Float):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_line_to_merge_duplicate(handle, posX, posY);
        #end
    }

    public function pathFillConvex(col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_path_fill_convex(handle, col);
        #end
    }

    public function pathFillConcave(col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_path_fill_concave(handle, col);
        #end
    }

    public function pathStroke(col:ImColor, thickness:Float = 1.0, flags:ImDrawFlags = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_path_stroke(handle, col, thickness, flags);
        #end
    }

    public function pathArcTo(centerX:Float, centerY:Float, radius:Float, a_min:Float, a_max:Float, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_arc_to(handle, centerX, centerY, radius, a_min, a_max, num_segments);
        #end
    }

    public function pathArcToFast(centerX:Float, centerY:Float, radius:Float, a_min_of_12:Int, a_max_of_12:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_arc_to_fast(handle, centerX, centerY, radius, a_min_of_12, a_max_of_12);
        #end
    }

    public function pathEllipticalArcTo(centerX:Float, centerY:Float, radiusX:Float, radiusY:Float, rot:Float, a_min:Float, a_max:Float, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_elliptical_arc_to(handle, centerX, centerY, radiusX, radiusY, rot, a_min, a_max, num_segments);
        #end
    }

    public function pathBezierCubicCurveTo(points:Array<Float>, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 6) return;
        NativeCFFI.lime_imgui_draw_list_path_bezier_cubic_curve_to(handle, points, num_segments);
        #end
    }

    public function pathBezierQuadraticCurveTo(points:Array<Float>, num_segments:Int = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        NativeCFFI.lime_imgui_draw_list_path_bezier_quadratic_curve_to(handle, points, num_segments);
        #end
    }

    public function pathRect(rect_minX:Float, rect_minY:Float, rect_maxX:Float, rect_maxY:Float, rounding:Float = 0.0, flags:ImDrawFlags = 0):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_path_rect(handle, rect_minX, rect_minY, rect_maxX, rect_maxY, rounding, flags);
        #end
    }

    public function addDrawCmd():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_add_draw_cmd(handle);
        #end
    }

    /*public function cloneOutput():ImDrawList
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        return NativeCFFI.lime_imgui_draw_list_clone_output(handle);
        #end
        return;
    }*/

    public function channelsSplit(count:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_channels_split(handle, count);
        #end
    }

    public function channelsMerge():Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_channels_merge(handle);
        #end
    }

    public function channelsSetCurrent(n:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_channels_set_current(handle, n);
        #end
    }

    public function primReserve(idx_count:Int, vtx_count:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_prim_reserve(handle, idx_count, vtx_count);
        #end
    }

    public function primUnreserve(idx_count:Int, vtx_count:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_prim_unreserve(handle, idx_count, vtx_count);
        #end
    }

    public function primRect(points:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_prim_rect(handle, points, col);
        #end
    }

    public function primRectUV(points:Array<Float>, uvPoints:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 4) return;
        if (uvPoints == null || uvPoints.length < 4) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_prim_rect_u_v(handle, points, uvPoints, col);
        #end
    }

    public function primQuadUV(points:Array<Float>, uvPoints:Array<Float>, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        if (points == null || points.length < 8) return;
        if (uvPoints == null || uvPoints.length < 8) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_prim_quad_u_v(handle, points, uvPoints, col);
        #end
    }

    public function primWriteVtx(posX:Float, posY:Float, uvX:Float, uvY:Float, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_prim_write_vtx(handle, posX, posY, uvX, uvY, col);
        #end
    }

    public function primWriteIdx(idx:Int):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        NativeCFFI.lime_imgui_draw_list_prim_write_idx(handle, idx);
        #end
    }

    public function primVtx(posX:Float, posY:Float, uvX:Float, uvY:Float, col:ImColor):Void
    {
        #if (lime_cffi && lime_imgui && !macro && cpp && !cppia && !disable_cffi)
        if (!isValid()) return;
        col = ((col.a & 0xFF) << 24) | ((col.b & 0xFF) << 16) | ((col.g & 0xFF) << 8) | (col.r & 0xFF);
        NativeCFFI.lime_imgui_draw_list_prim_vtx(handle, posX, posY, uvX, uvY, col);
        #end
    }
}

@:access(lime._internal.backend.native.NativeCFFI)
class ImDrawListSharedData extends ImGuiPtrHandle
{
    //dunno if this is needed
}