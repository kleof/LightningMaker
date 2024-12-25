

//if (not surface_exists(surf)) {
//	surf = surface_create(room_width, room_height);
//}
//surface_set_target(surf);
//draw_clear_alpha(c_black, 0);

bolt.glow_set();
bolt.draw();
//bolt2.draw();
//bolt3.draw();
//bolt4.draw();
//bolt5.draw();
bolt.glow_reset_disk();

//bolt.update();
//bolt2.update();
//bolt3.update();

//for (var i = 0; i < array_length(bolts); i++) {
//	bolts[i].draw();
//}
draw_text(10, 700, $"fps_real:   {fps_real}");
draw_text(10, 700, $"\nframe time: {1000 / fps_real} /16.67ms");
draw_text(10, 700, $"\n\nfps:        {fps}");


//surface_reset_target();

//gpu_set_blendmode(bm_add);
//shader_set(shd_outline_mimpy);
//shader_set_uniform_f(tex_uniform, 1/room_width, 1/room_height);
//shader_set_uniform_f(outline_width_uniform, 3);

//draw_surface(surf, 0, 0); 

//shader_reset();
//gpu_set_blendmode(bm_normal);


