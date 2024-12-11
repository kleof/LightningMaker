#macro trace show_debug_message

function remap(_value, _value_min, _value_max, _target_min, _target_max) {
    return (((_value - _value_min) / (_value_max - _value_min)) * (_target_max - _target_min)) + _target_min;
}

function Point(_x, _y) constructor {
	x = _x;
	y = _y;
}

function lightning(x1,y1, x2,y2, segment, density, height, spd) {
	var smoothing_base = animcurve_get_channel(ac_smoothing, "gentle");
	var smoothing_secondary = animcurve_get_channel(ac_smoothing, "rapid2");
	
	var angle = point_direction(x1,y1, x2,y2);
	var dist = point_distance(x1,y1, x2,y2);
	var num = floor(dist / segment);
	segment = dist / num;
	
	var s = 0;
	var s_secondary = 0;
	var x_offset = 0;
	var secondary_noise = 0;
	var base_noise = 0;
	var y_offset = 0;
	
	for (var i = 1; i <= num; i++) {
		var prev_s = s;
		var prev_s_secondary = s_secondary;
		var prev_x_offset = x_offset;
		var prev_secondary_noise = secondary_noise;
		var prev_base_noise = base_noise;
		var prev_y_offset = y_offset;
		
		s = animcurve_channel_evaluate(smoothing_base, (i)/(num));
		s_secondary = animcurve_channel_evaluate(smoothing_secondary, (i)/(num));
		x_offset = i * segment;
		secondary_noise = perlin_noise(x_offset * density*2, spd);
		base_noise = perlin_noise(x_offset * density, spd);
		y_offset = base_noise * height * s + secondary_noise * height/6 * s_secondary;
		
		var prev_x = x1 + lengthdir_x(prev_x_offset, angle) + lengthdir_x(prev_y_offset, angle+90);
		var prev_y = y1 + lengthdir_y(prev_x_offset, angle) + lengthdir_y(prev_y_offset, angle+90);
		
		var nx = x1 + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle+90);
		var ny = y1 + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle+90);
		
		draw_set_alpha(.2);
		draw_set_color(c_aqua);
		draw_line_width(prev_x, prev_y, nx, ny, 12);
		draw_line_width(prev_x, prev_y, nx, ny, 10);
		draw_line_width(prev_x, prev_y, nx, ny, 6);
		draw_line_width(prev_x, prev_y, nx, ny, 4);
	
		draw_set_alpha(1);
		draw_set_color(c_white);
		draw_line_width(prev_x, prev_y, nx, ny, 3);
	}
}

