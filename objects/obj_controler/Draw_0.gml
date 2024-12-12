
// ANIM ----------- CURVEEEEEEEEEEEEEEEEEEEEEEEEEEES!

//var angle = point_direction(start_p.x, start_p.y, mouse_x, mouse_y);


//for (var i = 1; i < len; i++) {
//	var g = animcurve_channel_evaluate(smoothing_base, i/(len-1));
//	var g_prev = animcurve_channel_evaluate(smoothing_base, (i-1)/(len-1));
	
//	var g2 = animcurve_channel_evaluate(smoothing_secondary, i/(len-1));
//	var g2_prev = animcurve_channel_evaluate(smoothing_secondary, (i-1)/(len-1));
	
//	var prev_x = (i-1) * segment;
//	var v_prev = perlin_noise(prev_x * density*2, spd); // variety
//	var prev_y = perlin_noise(prev_x * density, spd) * height * g_prev + v_prev*20//*g2_prev;
//	var nx = i * segment;
//	var v = perlin_noise(nx * density*2, spd); // variety
//	var ny = perlin_noise(nx * density, spd) * height * g + v*20//*g2;
	
	
//	prev_x = start_p.x + lengthdir_x(prev_x, angle) + lengthdir_x(prev_y, angle+90);
//	prev_y = start_p.y + lengthdir_y(prev_x, angle) + lengthdir_y(prev_y, angle+90);
//	nx = start_p.x + lengthdir_x(nx, angle) + lengthdir_x(ny, angle+90);
//	ny = start_p.y + lengthdir_y(nx, angle) + lengthdir_y(ny, angle+90);
	
//	//gpu_set_blendmode(bm_add);
//	///*
//	draw_set_alpha(.2);
//	draw_set_color(c_aqua);
//	draw_line_width(prev_x, prev_y, nx, ny, 12);
//	draw_line_width(prev_x, prev_y, nx, ny, 10);
//	draw_line_width(prev_x, prev_y, nx, ny, 6);
//	draw_line_width(prev_x, prev_y, nx, ny, 4);
	
//	//gpu_set_blendmode(bm_normal);
//	draw_set_alpha(1);
//	draw_set_color(c_white);
//	draw_line(prev_x, prev_y, nx, ny);
//	//*/
//}

//var dist2 = point_distance(start_p.x, start_p.y, mouse_x, mouse_y);
//var angle2 = point_direction(start_p.x, start_p.y, mouse_x, mouse_y);

//var seg = 12;
//var len2 = floor(dist2/seg);
//seg = dist2/len2;

//for (var i = 1; i <= len2; i++) {
//	var p0_x_offset = (i-1) * seg;
//	var p0_y_offset = ((i-1) % 2) * 30;
//	var p1_x_offset = i * seg;
//	var p1_y_offset = (i % 2) * 30;
	
//	var x0 = start_p.x + lengthdir_x(p0_x_offset, angle2) + lengthdir_x(p0_y_offset, angle2+90);
//	var y0 = start_p.y + lengthdir_y(p0_x_offset, angle2) + lengthdir_y(p0_y_offset, angle2+90);
	
//	var x1 = start_p.x + lengthdir_x(p1_x_offset, angle2) + lengthdir_x(p1_y_offset, angle2+90);
//	var y1 = start_p.y + lengthdir_y(p1_x_offset, angle2) + lengthdir_y(p1_y_offset, angle2+90);
	
//	draw_line(x0, y0, x1, y1);
//}

//var t = current_time;
//repeat (20) 
	//lightning(100,300, mouse_x,mouse_y, 12, .25, 120, -.1);

bolt.draw();

//trace((current_time - t));
