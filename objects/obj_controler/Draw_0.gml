	
//	//gpu_set_blendmode(bm_max);	
//	//gpu_set_blendmode(bm_normal);


//if (not surface_exists(surf)) {
//	surf = surface_create(room_width, room_height);
//}
//surface_set_target(surf);
//draw_clear_alpha(c_black, 1);

bolt.draw();
//for (var i = 0; i < array_length(bolts); i++) {
//	bolts[i].draw();
//}

//surface_reset_target();

//shader_set(shd_bloom);
//shader_set_uniform_f(shader_get_uniform(shd_bloom, "intensity"), .9);
//gpu_set_blendmode(bm_max);
//draw_surface(surf, 0, 0); // draw surface with add/mult blendmode?
//gpu_set_blendmode(bm_normal);
//shader_reset();



// ===== XOR KAWASE BLUR =====

//kawase_set();
//draw_surface(surf, 0, 0);
//kawase_reset();

//gpu_set_blendmode(bm_max);
//kawase_draw(1);
//kawase_draw(3);
//gpu_set_blendmode(bm_normal);



// ===== XOR 1PASS BLUR =====

//blur_set(surf, .15);
//gpu_set_blendmode(bm_max);
//draw_surface(surf, 0, 0);
//blur_reset();

//blur_set(surf, 1);
//draw_surface(surf, 0, 0);
//blur_reset();

//blur_set(surf, .2);
//draw_surface(surf, 0, 0);
//blur_reset();

//gpu_set_blendmode(bm_normal);
