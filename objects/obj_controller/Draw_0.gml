
bolt.glow_set();

bolt.draw();

//gpu_set_blendmode(bm_max);
//draw_line_width_color(start_handle.x, start_handle.y, end_handle.x, end_handle.y, 18, #D6007C, #D6007C);
//draw_line_width(start_handle.x, start_handle.y, end_handle.x, end_handle.y, 10);

//for (var i = 0; i < array_length(bolts); i++) {
//	bolts[i].draw();
//}

bolt.glow_reset();




var tx = 1130;
var ty = 730;
draw_text(tx, ty, $"fps_real:   {fps_real}");
draw_text(tx, ty, $"\nframe time: {1000 / fps_real} /16.67ms");
draw_text(tx, ty, $"\n\nfps:        {fps}");








