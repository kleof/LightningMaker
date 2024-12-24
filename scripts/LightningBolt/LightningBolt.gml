

//*****     --_./\/\./``\__/`\/\.-->     *****//

function Lightning(_start_point, _end_point, _segment, _density, _height, _speed, _width, _color, _smoothing_type=1) constructor {
	// Surfaces and shaders statics
	static surf_base = -1;
	static surf_pass = -1;
	static surf_width = 1;
	static surf_height = 1;
	static blur_horizontal_glow_uniform = shader_get_uniform(shd_blur_horizontal, "u_glowProperties");
	static blur_horizontal_time_uniform = shader_get_uniform(shd_blur_horizontal, "u_time");
	static blur_vertical_glow_uniform = shader_get_uniform(shd_blur_vertical, "u_glowProperties");
	static blur_vertical_time_uniform = shader_get_uniform(shd_blur_vertical, "u_time");
	
	static min_segments_number = 3; // Increase if you need more fluid movement at low lightning's lengths
	
	glow_outer_intensity = 2;
	glow_inner_intensity = 10;
	glow_inner_multiplier = 22;
	glow_color = _color;
	
	smoothing_type = _smoothing_type;
	smoothing_base_type = animcurve_get_channel(ac_smoothing, smoothing_type);
	smoothing_secondary_type = animcurve_get_channel(ac_smoothing, "rapid2");
	secondary_noise_strength = .17; // jaggedness
	secondary_noise_density_multiplier = 2; // jaggedness
	start_point = _start_point;
	end_point = _end_point;
	base_segment = max(1, _segment); // segment length in pixels, aka "quality", bigger -> better performance
	density = _density; // Wave length, precision, quality
	height = _height; // Max wave height, in pixels // (amplitude)
	spd = _speed;
	width = _width; // line width/thickness
	turbulence = 0; // slow it down, change every other/3rd frame?
	outline_strength = 4; // <- TODO
	
	// Private variables, add _ ?
	is_parent = true;
	is_child = false;
	// temporary solution for built-in glow effect
	static _layer = other.layer;
	static _fx = fx_create("_effect_glow");
	fx_set_parameters(_fx, {g_GlowIntensity: 1, g_GlowGamma: .9});
	fx_set_single_layer(_fx, true);
	layer_set_fx(_layer, _fx);
	
	angle = 0;
	num = -1;
	segment = 0;
	height_reduction = 0;
	points = []; // only populate points array if it's a parent, hmmm, but it will be too late as this will execute before we're chaning is_parent to false, until we pass is_parent as argument?
	__update_distance_params();
	
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
		// set surfaces and shaders only in "root" lightning
		
		if (is_child) __update_distance_params(); // Not necessary for "root" lightning (if not a child), as start/end points are only going to change through update_start/end methods
		var nx = start_point.x;
		var ny = start_point.y;
		
		
		if (is_parent) points[0].update_position(nx, ny); // merge with below
		// move babies conception to separate method?
		if (is_parent && random(1) < child_chance && array_length(children) < children_max) {
			// no children if too short
			var range = num; // if range too small (min_length+2), no children - ^^^ add to conditions above ^^^
			var cutoff = 0 //max(1, floor(range * .1)); // move to static class variables
			var min_length = 3; //higher probability for longer lengths? // can't be higher than min_segments // relative to whole length (dist from start to end)
			var p1_index = irandom_range(cutoff, range - cutoff - min_length);
			var p2_index = irandom_range(p1_index + min_length, range - cutoff);
			
			var new_child = new Lightning(points[p1_index], points[p2_index], base_segment, density, height*.8, spd, max(1, width-2), glow_color, smoothing_type);
			// child height relative to it's length?
			// reduce alpha for children?
			new_child.recursion_level = recursion_level + 1;
			new_child.is_parent = (new_child.recursion_level < recursion_level_max) ? true : false;
			new_child.is_child = true;
			new_child.life = irandom_range(child_life_min, child_life_max);
			new_child.turbulence = turbulence; // ?
			new_child.outline_strength = outline_strength;
			array_push(children, new_child);
		}
		
		//gpu_set_blendmode(bm_add); // *for drawing outline with draw_line
		for (var i = 1; i <= num; i++) {
			var prev_x = nx;
			var prev_y = ny;
			
			var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
			var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
			var x_offset = i * segment + random_range(-turbulence, turbulence) * smoothing_secondary;
			var base_noise = perlin_noise(noise_offset + x_offset * density, spd);
			var secondary_noise = perlin_noise(noise_offset + x_offset * density * secondary_noise_density_multiplier, spd);
			var y_offset = base_noise * height * height_reduction * smoothing + (secondary_noise * height * secondary_noise_strength + random(turbulence) * choose(-1,1)) * smoothing_secondary;
			
			nx = start_point.x + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle + 90);
			ny = start_point.y + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle + 90);
			
			if (is_parent) points[i].update_position(nx, ny); // update only point indexes belonging to children? BUT how to check them and remove when needed?
			
			//if (outline_strength > 0) draw_line_width_color(prev_x, prev_y, nx, ny, width + max(1, outline_strength / (recursion_level+1)), #D6007C, #D6007C);
			draw_line_width_color(prev_x, prev_y, nx, ny, width, glow_color, glow_color);
			//draw_line_width(prev_x, prev_y, nx, ny, 1); // make toggable, allow to set width
		}
		//gpu_set_blendmode(bm_normal); // *for drawing outline with draw_line
		
		if (is_parent) {
			for (var k = 0; k < array_length(children); k++) {
				var child = children[k];
				with (child) {
					life--; // hmmm, may be affected by reduced drawing mode?
					
					// Deleting dead children or whos endpoint got deactivated, and by extension all of their children are lost (right?)
					if (life <= 0 || end_point.active == false) { // end_point should be enough, no need for start_point
						array_delete(other.children, array_get_index(other.children, self), 1);
						return;
					}
					
					draw();
				}
			}
		}
	}
	
	static glow_set = function() {
		// Setting up surfaces
		var _surf_width = camera_get_view_width(camera_get_active());
		var _surf_height = camera_get_view_height(camera_get_active());
		if (!surface_exists(surf_base)) {
			surf_base = surface_create(_surf_width, _surf_height);
		}
		else if ((surf_width != _surf_width)  || (surf_height != _surf_height)) {
			surface_resize(surf_base, _surf_width, _surf_height);
		}
		if (!surface_exists(surf_pass)) {
			surf_pass = surface_create(_surf_width, _surf_height);
		}
		else if ((surf_width != _surf_width)  || (surf_height != _surf_height)) {
			surface_resize(surf_pass, _surf_width, _surf_height);
		}
		surf_width = _surf_width;
		surf_height = _surf_height;
		
		surface_set_target(surf_base);
		draw_clear_alpha(c_black, 1);
	}
	
	static glow_reset = function() {
		surface_reset_target();
		var time = current_time;
		
		// Horizontal blur
		surface_set_target(surf_pass); {
			//draw_clear_alpha(c_black, 0); // why don't we need to clear this one? probably because of "gpu_set_blendenable(false)" later?
			
			shader_set(shd_blur_horizontal); {
				shader_set_uniform_f(blur_horizontal_glow_uniform, glow_outer_intensity, glow_inner_intensity, glow_inner_multiplier);
				shader_set_uniform_f(blur_horizontal_time_uniform, time); // rather subtle effect, but why not

				gpu_set_blendenable(false); // important!
				draw_surface(surf_base, 0, 0);
				gpu_set_blendenable(true);

			} shader_reset();
		} surface_reset_target();
		
		// Final drawing: Vertical blur + Blending
		gpu_set_blendmode(bm_add);

		shader_set(shd_blur_vertical); {
			shader_set_uniform_f(blur_vertical_glow_uniform, glow_outer_intensity, glow_inner_intensity, glow_inner_multiplier);
			shader_set_uniform_f(blur_vertical_time_uniform, time);
			draw_surface(surf_pass, 0, 0);
			
		} shader_reset();
		
		gpu_set_blendmode(bm_normal);
	}
	
	static update = function() {
		glow_set();
		draw();
		glow_reset();
	}
	
	static __update_distance_params = function() {
		var prev_num = num;
		var dist = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		num = max(min_segments_number, floor(dist / base_segment)); // Number of segments from start to end 
		segment = dist / num; // In case given segment can't divide distance evenly, resize it
		height_reduction = (dist > 50) ? 1 : (dist / 100); // Reduce height for small distances
		
		// In case of parent, "resize" array of all points when distance changes
		if (is_parent) {
			// Add new points if lightning length increased, but not if array is long enough already
			var _diff = num - prev_num;
			if (_diff > 0 && array_length(points) <= num) {
				var _additional_points = array_create_ext(_diff, function() { return new LPoint(0, 0); });
				points = array_concat(points, _additional_points);
			}
			// Deactivate points (not delete) if lightning length decreased, so we can destroy children using them
			else if (_diff < 0) {
				for (var i = num; i <= prev_num; i++) {
					points[i].active = false;
				}
			}
		}
	}
	
	#region SETTERS
	
	static update_start = function(_x, _y) {
		start_point.x = _x;
		start_point.y = _y;
		__update_distance_params();
		return self;
	}
	
	static update_end = function(_x, _y) {
		end_point.x = _x;
		end_point.y = _y;
		__update_distance_params();
		return self;
	}
	
	static set_segment = function(_segment) {
		base_segment = _segment;
		__update_distance_params();
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
	
	static set_outline_strength = function(_outline_strength) {
		outline_strength = _outline_strength;
		return self;
	}
	
	static set_glow_outer_intensity = function(_glow_outer_intensity) {
		glow_outer_intensity = _glow_outer_intensity;
		return self;
	}
	
	static set_glow_inner_intensity = function(_glow_inner_intensity) {
		glow_inner_intensity = _glow_inner_intensity;
		return self;
	}
	
	static set_glow_inner_multiplier = function(_glow_inner_multiplier) {
		glow_inner_multiplier = _glow_inner_multiplier;
		return self;
	}
	
	static set_glow_color = function(_glow_color) {
		glow_color = _glow_color;
		
		// for smooth parameter changes that should affect children immediately, not just the newly created ones
		// TODO add to rest setters
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_glow_color(_glow_color);
			}
		}
		return self;
	}
	
	#endregion
	
	// Freeing surfaces
	static cleanup = function() {
		// when do we actually suppose to call it though?
		if (surface_exists(surf_base)) {
			surface_free(surf_base);
			surf_base = -1;
		}
		if (surface_exists(surf_pass)) {
			surface_free(surf_pass);
			surf_pass = -1;
		}
	}
}


function LPoint(_x, _y) constructor {
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


