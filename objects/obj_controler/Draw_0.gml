//spd = remap(perlin_noise(1, .01), -1, 1, spd_base, spd_base*1.3);
//trace(string_format(spd, 1, 10));
//offset = random(1) > .01 ? offset : random(100);

// ANIM ----------- CURVEEEEEEEEEEEEEEEEEEEEEEEEEEES!

for (var i = 1; i < len; i++) {
	var g = animcurve_channel_evaluate(gradient, i/(len-1));
	var g_prev = animcurve_channel_evaluate(gradient, (i-1)/(len-1));
	var g2 = animcurve_channel_evaluate(variance, i/(len-1));
	var g2_prev = animcurve_channel_evaluate(variance, (i-1)/(len-1));
	
	var prev_x = start_p.x + (i-1) * segment;
	var v_prev = perlin_noise(prev_x * density*2 + offset, spd); // variety
	var prev_y = start_p.y + perlin_noise(prev_x * density + offset, spd) * height * g_prev + v_prev*20//*g2_prev;
	var nx = start_p.x + i * segment;
	var v = perlin_noise(nx * density*2 + offset, spd); // variety
	var ny = start_p.y + perlin_noise(nx * density + offset, spd) * height * g + v*20//*g2;
	
	if (i == 1) prev_y = start_p.y;
	else if (i == len - 1) ny = end_p.y;
	
	//gpu_set_blendmode(bm_add);
	draw_set_alpha(.2);
	draw_set_color(c_aqua);
	draw_line_width(prev_x, prev_y, nx, ny, 12);
	draw_line_width(prev_x, prev_y, nx, ny, 10);
	draw_line_width(prev_x, prev_y, nx, ny, 6);
	draw_line_width(prev_x, prev_y, nx, ny, 4);
	
	//gpu_set_blendmode(bm_normal);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_line(prev_x, prev_y, nx, ny);
}


