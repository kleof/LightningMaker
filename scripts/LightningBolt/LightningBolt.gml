#macro trace show_debug_message

function color_to_array(_color) {
	var _hex = [];
	var _ret = [];
	for (var i = 0; _color != 0; ++i) {
		_hex[i] = _color % 16;
		_color = floor( _color / 16);
	}
	
	// Make sure this is a color code
	while (array_length(_hex) < 6) {
		_hex[array_length(_hex)] = 0;
	}
	if (array_length( _hex) > 6) {
		show_error("Unknown color: " + string(_color), true);
		return -1;
	}
	
	// Convert _hex to RGB
	for (var i = 0; i < 3; ++i) {
		_ret[i] = _hex[i * 2 + 1] * 16 + _hex[i * 2];
		_ret[i] /= 255;
	}
	array_push(_ret, 1);
	
	return _ret;
}

function Point(_x, _y) constructor {
	x = _x;
	y = _y;
	active = true;
	
	static update_position = function(_x, _y) {
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
function Lightning(_start_point, _end_point, _segment, _density, _height, _speed, _width, _smoothing_type=1) constructor {
	
	static min_segments_number = 5;
	smoothing_type = _smoothing_type;
	smoothing_base_type = animcurve_get_channel(ac_smoothing, smoothing_type);
	smoothing_secondary_type = animcurve_get_channel(ac_smoothing, "rapid2");
	secondary_noise_strength = .17; // jaggedness
	secondary_noise_density_multiplier = 2; // jaggedness
	start_point = _start_point;
	end_point = _end_point;
	base_segment = max(1, _segment); // segment length in pixels, aka "quality"
	density = _density; // Wave length, precision, quality
	height = _height; // Max wave height, in pixels // (amplitude)
	spd = _speed;
	width = _width; // line width/thickness
	turbulence = 0;
	
	// Private variables
	is_parent = true;
	is_child = false;
	
	angle = 0;
	num = -1;
	segment = 0;
	height_reduction = 0;
	_update_distance_params();
	
	// only populate points array if it's a parent, hmmm, but it will be too late as this will execute before we're chaning is_parent to false, until we pass is_parent as argument?
	points = array_create_ext(200, function() { return new Point(0, 0); }); // set some max amount of points after which we draw only part of lightning, not reaching the endpoint
	
	noise_offset = random(500); // (?) 500 seems enough, but unsure what is the right value for this
	
	is_parent = true; // if children_max is 0 set to false?
	is_child = false;
	life = 0;
	recursion_level = 0;
	static child_chance = .10;
	static children_max = 3;
	static child_life_min = 6; // In frames (hmmm, may be affected by reduced drawing mode?)
	static child_life_max = 60;
	static recursion_level_max = 2;
	children = [];
	
	static draw = function() {
		//noise_offset = random(500);
		
		if (is_child) _update_distance_params(); // Not necessary if not a child, as start/end points are only going to change through update_start/end methods
		var nx = start_point.x;
		var ny = start_point.y;
		
		if (is_parent) points[0].update_position(nx, ny); // merge with below
		if (is_parent && random(1) < child_chance && array_length(children) < children_max) {
			// no children if too short
			var range = num; // if range too small (min_length+2), no children - ^^^ add to conditions above ^^^
			var cutoff = 0 //max(1, floor(range * .1)); // move to static class variables
			var min_length = 5; //higher probability for longer lengths?
			var p1_index = irandom_range(cutoff, range - cutoff - min_length);
			var p2_index = irandom_range(p1_index + min_length, range - cutoff);
			
			var new_child = new Lightning(points[p1_index], points[p2_index], base_segment, density, height*.8, spd, max(1, width-2), smoothing_type);
			// child height relative to it's length?
			// reduce alpha for children?
			new_child.recursion_level = recursion_level + 1;
			new_child.is_parent = (new_child.recursion_level < recursion_level_max) ? true : false;
			new_child.is_child = true;
			new_child.life = irandom_range(child_life_min, child_life_max);
			new_child.turbulence = turbulence; // ?
			array_push(children, new_child);
		}
		
		for (var i = 1; i <= num; i++) {
			var prev_x = nx;
			var prev_y = ny;
			
			var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
			var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
			var x_offset = i * segment + random(turbulence) * choose(-1,1) * smoothing_secondary;
			var base_noise = perlin_noise(noise_offset + x_offset * density, spd);
			var secondary_noise = perlin_noise(noise_offset + x_offset * density * secondary_noise_density_multiplier, spd);
			var y_offset = base_noise * height * height_reduction * smoothing + (secondary_noise * height * secondary_noise_strength + random(turbulence) * choose(-1,1)) * smoothing_secondary;
			
			nx = start_point.x + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle + 90);
			ny = start_point.y + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle + 90);
			
			if (is_parent) points[i].update_position(nx, ny); // update only point indexes belonging to children? BUT how to check them and remove when needed?
			
			
			draw_line_width(prev_x, prev_y, nx, ny, width);
		}
		
		if (is_parent) {
			for (var k = 0; k < array_length(children); k++) {
				var child = children[k];
				with (child) {
					life--; // hmmm, may be affected by reduced drawing mode?
					
					if (life <= 0 || end_point.active == false) { // end_point should be enough, no need for start_point
						array_delete(other.children, array_get_index(other.children, self), 1);
						return;
					}
					
					draw();
				}
			}
		}

	}
	
	static update_start = function(_x, _y) {
		start_point.x = _x;
		start_point.y = _y;
		_update_distance_params();
		return self;
	}
	
	static update_end = function(_x, _y) {
		end_point.x = _x;
		end_point.y = _y;
		_update_distance_params();
		return self;
	}
	
	static set_segment = function(_segment) {
		base_segment = _segment;
		_update_distance_params();
		return self;
	}
	
	static set_density = function(_density) {
		density = _density;
		return self;
	}
	
	static set_height = function(_height) {
		height = _height;
		return self;
	}
	
	static set_speed = function(_speed) {
		spd = _speed;
		return self;
	}
	
	static set_width = function(_width) {
		width = _width;
		return self;
	}
	
	static set_turbulence = function(_turbulence) {
		turbulence = _turbulence;
		return self;
	}
	
	static _update_distance_params = function() {
		var prev_num = num;
		var dist = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		num = max(min_segments_number, floor(dist / base_segment)); // Number of segments from start to end 
		segment = dist / num; // In case given segment can't divide distance evenly, we resize it
		height_reduction = (dist > 50) ? 1 : (dist / 100); // Reduce height for small distances
		
		// Deactivate points outside of new range so we can destroy children using them
		if (is_parent && num < prev_num) {
			for (var i = num; i <= prev_num; i++) {
				points[i].active = false;
			}
		}
	}
}


