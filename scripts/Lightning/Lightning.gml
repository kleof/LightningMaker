#macro trace show_debug_message

function remap(_value, _value_min, _value_max, _target_min, _target_max) {
    return (((_value - _value_min) / (_value_max - _value_min)) * (_target_max - _target_min)) + _target_min;
}

function Point(_x, _y) constructor {
	x = _x;
	y = _y;
	active = true;
	
	static set_position = function(_x, _y) {
		x = _x;
		y = _y;
		
		// If they are being set, means they are active
		active = true;
	}
}

// rest in peace prototype function o7
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
	
	var nx = x1;
	var ny = y1;
	
	for (var i = 1; i <= num; i++) {
		var prev_x = nx;
		var prev_y = ny;
		
		var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
		var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
		x_offset = i * segment;
		var base_noise = perlin_noise(x_offset * density, spd);
		var secondary_noise = perlin_noise(x_offset * density * secondary_noise_density_multiplier, spd);
		y_offset = (base_noise * height * smoothing) + (secondary_noise * height * secondary_noise_strength * smoothing_secondary);
		
		nx = x1 + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle+90);
		ny = y1 + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle+90);
		
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

// long live the new queen \o/
function Lightning(_start_point, _end_point, _segment, _density, _height, _spd, _width, _smoothing_type=1) constructor {
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
	width = _width; // line width/thickness
	angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
	dist = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
	base_segment = max(1, _segment); // segment length in pixels, aka "quality"
	num = max(min_segments_number, floor(dist / base_segment)); // Number of segments from start to end 
	segment = dist / num; // In case given segment can't divide distance evenly we resize it
	height_reduction = (dist > 50) ? 1 : (dist / 100); // Reduse height for small distances
	noise_offset = random(500); // what is the right range for this???
	
	is_parent = true;
	is_child = false;
	life = 0;
	recursion_level = 0;
	static child_chance = .10;
	static children_max = 3;
	static child_life_min = 6; // In frames (hmmm, may be affected by reducted drawing mode?)
	static child_life_max = 60;
	static recursion_level_max = 2;
	points = array_create_ext(200, function() { return new Point(0, 0); });
	children = [];
	parent_array = [];
	
	static draw = function() {
		if (is_child) life--; // hmmm, may be affected by reducted drawing mode?
		if (is_child && (life <= 0 || end_point.active == false)) { // is end_point enough or should check start_point too?
			array_delete(parent_array, array_get_index(parent_array, self), 1);
			return;
		}
		
		_update_params(); // hmm, we need to update only if endpoints changed, add condition to this?
		var nx = start_point.x;
		var ny = start_point.y;
		
		if (is_parent && random(1) < child_chance && array_length(children) < children_max) {
			var range = num; // if range too small (min_length+2), no children - ^^^ add to conditions above ^^^
			var cutoff = 0 //max(1, floor(range * .1)); // move to static class variables
			var min_length = 5;
			var p1_index = irandom_range(cutoff, range - cutoff - min_length);
			var p2_index = irandom_range(p1_index + min_length, range - cutoff);
			
			var new_child = new Lightning(points[p1_index], points[p2_index], base_segment, density, height*.8, spd, max(1, width-2), smoothing_type, false);
			// child height relative to it's length?
			new_child.recursion_level = recursion_level + 1;
			new_child.is_parent = (new_child.recursion_level < recursion_level_max) ? true : false;
			new_child.parent_array = children;
			new_child.is_child = true;
			new_child.life = irandom_range(child_life_min, child_life_max);
			array_push(children, new_child);
		}
		if (is_parent) points[0].set_position(nx, ny); // consolidate with above ^
		
		for (var i = 1; i <= num; i++) {
			var prev_x = nx;
			var prev_y = ny;
			
			var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
			var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
			var x_offset = i * segment // + random(segment)*choose(-1,1); // random roughness!
			var base_noise = perlin_noise(noise_offset + x_offset * density, spd);
			var secondary_noise = perlin_noise(noise_offset + x_offset * density * secondary_noise_density_multiplier, spd);
			var y_offset = base_noise * height * height_reduction * smoothing + secondary_noise * height * secondary_noise_strength * smoothing_secondary;
			
			nx = start_point.x + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle+90);
			ny = start_point.y + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle+90);
			
			if (is_parent) points[i].set_position(nx, ny); // TODO update only point indexes belonging to children?
			
			
			draw_line_width(prev_x, prev_y, nx, ny, width);
		}
		
		if (is_parent) {
			for (var k = 0; k < array_length(children); k++) {
				children[k].draw();
			}
		}
	}
	
	static _update_params = function() {
		// Not necessary if endpoints are stationary
		var prev_num = num;
		dist = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		num = max(min_segments_number, floor(dist / base_segment));
		segment = dist / num;
		height_reduction = (dist > 50) ? 1 : (dist / 100);
		
		// Deactivate points outside of new range so child lightnings using them can destroy themselves
		if (is_parent && num < prev_num) {
			for (var i = num; i <= prev_num; i++) {
				points[i].active = false;
			}
		}
	}
	
}


