#macro trace show_debug_message

function remap(_value, _value_min, _value_max, _target_min, _target_max) {
    return (((_value - _value_min) / (_value_max - _value_min)) * (_target_max - _target_min)) + _target_min;
}

function Point(_x, _y) constructor {
	x = _x;
	y = _y;
	
	static set_position = function(_x, _y) {
		x = _x;
		y = _y;
	}
}

function lightning(x1,y1, x2,y2, segment, density, height, spd, smoothing_type=1) {
	// Option to draw every 2nd/3rd frame
	var smoothing_base_type = animcurve_get_channel(ac_smoothing, smoothing_type);
	var smoothing_secondary_type = animcurve_get_channel(ac_smoothing, "rapid2");
	var secondary_noise_strength = .17; // jaggedness
	var secondary_noise_density_multiplier = 2; // jaggedness
	var noise_offset = random(1); // hmmmmmm
	
	var angle = point_direction(x1,y1, x2,y2);
	var dist = point_distance(x1,y1, x2,y2);
	var num = max(5, floor(dist / segment)); // Number of points from start to end // Min number of segments: 5
	segment = dist / num; // In case given segment can't divide distance evenly we resize it
	
	var x_offset = 0;
	var y_offset = 0;
	
	for (var i = 1; i <= num; i++) {
		var prev_x_offset = x_offset;
		var prev_y_offset = y_offset;
		
		var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
		var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
		x_offset = i * segment;
		var base_noise = perlin_noise(x_offset * density, spd);
		var secondary_noise = perlin_noise(x_offset * density * secondary_noise_density_multiplier, spd);
		y_offset = (base_noise * height * smoothing) + (secondary_noise * height * secondary_noise_strength * smoothing_secondary);
		
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

function Lightning(_start_point, _end_point, _segment, _density, _height, _spd, _width, _smoothing_type=1, _is_parent=true) constructor {
	// Option to draw every 2nd/3rd frame
	static min_segments_number = 5;
	smoothing_type = _smoothing_type;
	smoothing_base_type = animcurve_get_channel(ac_smoothing, smoothing_type);
	smoothing_secondary_type = animcurve_get_channel(ac_smoothing, "rapid2");
	secondary_noise_strength = .17; // jaggedness
	secondary_noise_density_multiplier = 2; // jaggedness
	start_point = _start_point;
	end_point = _end_point;
	density = _density; // Wave length
	height = _height; // Wave height, amplitude
	spd = _spd;
	width = _width;
	angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
	dist = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
	base_segment = _segment;
	num = max(min_segments_number, floor(dist / base_segment)); // Number of points from start to end // Min number of segments: 5
	segment = dist / num; // In case given segment can't divide distance evenly we resize it
	height_reduction = (dist > 50) ? 1 : (dist / 100); // Reduse height for small distances
	noise_offset = random(500); // what is the right range for this???
	
	is_parent = _is_parent;
	static child_chance = .05;
	static max_children = 3;
	points = array_create_ext(200, function() { return new Point(0, 0); });
	children = [];
	
	static draw = function() {
		_update_params();
		var nx = start_point.x;
		var ny = start_point.y;
		
		if (is_parent && random(1) < child_chance && array_length(children) <= max_children) {
			var range = num; // if range too small (min_length+2), no children - ^^^ add to conditions above ^^^
			var cutoff = max(1, floor(range * .1));
			var min_length = 3;
			var p1_index = irandom_range(cutoff, range - cutoff - min_length);
			var p2_index = irandom_range(p1_index + min_length, range - cutoff);
			
			var new_child = new Lightning(points[p1_index], points[p2_index], base_segment, density, height*.8, spd, max(1, width-2), smoothing_type, false);
			array_push(children, new_child);
		}
		if (is_parent) points[0].set_position(nx, ny);
		
		for (var i = 1; i <= num; i++) {
			var prev_x = nx;
			var prev_y = ny;
			
			var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
			var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
			var x_offset = i * segment;
			var base_noise = perlin_noise(noise_offset + x_offset * density, spd);
			var secondary_noise = perlin_noise(noise_offset + x_offset * density * secondary_noise_density_multiplier, spd);
			var y_offset = base_noise * height * height_reduction * smoothing + secondary_noise * height * secondary_noise_strength * smoothing_secondary;
		
			nx = start_point.x + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle+90);
			ny = start_point.y + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle+90);
			
			if (is_parent) points[i].set_position(nx, ny);
		
			//draw_set_alpha(.2);
			//draw_set_color(c_aqua);
			//draw_line_width(prev_x, prev_y, nx, ny, 12);
			//draw_line_width(prev_x, prev_y, nx, ny, 10);
			//draw_line_width(prev_x, prev_y, nx, ny, 6);
			//draw_line_width(prev_x, prev_y, nx, ny, 4);
	
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_line_width(prev_x, prev_y, nx, ny, width);
		}
		
		if (is_parent) {
			for (var k = 0; k < array_length(children); k++) {
				children[k].draw();
			}
		}
	}
		
	static set_start = function(_x, _y) {
		start_point.x = _x;
		start_point.y = _y;
		//_update_params();
	}
	
	static set_end = function(_x, _y) {
		end_point.x = _x;
		end_point.y = _y;
		//_update_params();
	}
	
	static _update_params = function() {
		dist = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		num = max(min_segments_number, floor(dist / base_segment));
		segment = dist / num;
		height_reduction = (dist > 50) ? 1 : (dist / 100);
	}
	
}


