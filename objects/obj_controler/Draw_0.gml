

bolt.glow_set();
bolt.draw();
//gpu_set_blendmode(bm_max);
//draw_line_width_color(start_handle.x, start_handle.y, end_handle.x, end_handle.y, 18, #D6007C, #D6007C);
//draw_line_width(start_handle.x, start_handle.y, end_handle.x, end_handle.y, 10);

//bolt2.draw();
//bolt3.draw();
//bolt4.draw();
//bolt5.draw();
bolt.glow_reset();

//bolt.update();
//bolt2.update();
//bolt3.update();

//for (var i = 0; i < array_length(bolts); i++) {
//	bolts[i].draw();
//}
draw_text(1130, 700, $"fps_real:   {fps_real}");
draw_text(1130, 700, $"\nframe time: {1000 / fps_real} /16.67ms");
draw_text(1130, 700, $"\n\nfps:        {fps}");

//draw_text(30,30, $"{start_point} {end_point}");
//draw_text(30,30, $"{bolt.child_length_min} {bolt.child_length_max}");
counter += 1;
average += 1000 / max(200, fps_real);
draw_text(1130, 700, $"\n\n\nAverage: {average / counter}");










