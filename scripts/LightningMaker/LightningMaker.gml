#macro GLOW_TYPE_NONE 0
#macro GLOW_TYPE_NEON 1
#macro GLOW_TYPE_DISK 2
#macro SMOOTHING_RAPID 0
#macro SMOOTHING_GENTLE 1
#macro SMOOTHING_SINE 2
#macro SMOOTHING_RAPID2 3
#macro SMOOTHING_OPENEND 4

//*****     --_./\/\./``\__/`\/\.-->     *****//

function Lightning(_start_point, _end_point, _segment) constructor {
	// Surfaces and shaders statics
	static surf_base = -1;
	static surf_pass = -1;
	static surf_width = 1;
	static surf_height = 1;
	static uniform_blur_horizontal_glow = shader_get_uniform(shd_blur_horizontal, "u_glowProperties");
	static uniform_blur_horizontal_time = shader_get_uniform(shd_blur_horizontal, "u_time");
	static uniform_blur_vertical_glow = shader_get_uniform(shd_blur_vertical, "u_glowProperties");
	static uniform_blur_vertical_time = shader_get_uniform(shd_blur_vertical, "u_time");
	static uniform_disk_glow_radius = shader_get_uniform(shd_disk_glow, "g_GlowRadius");
	static uniform_disk_glow_gamma = shader_get_uniform(shd_disk_glow, "g_GlowGamma");
	static uniform_disk_glow_texel_size  = shader_get_uniform(shd_disk_glow, "gm_pSurfaceTexelSize");
	glow_type = GLOW_TYPE_DISK;
	
	__glow_reset_function = __glow_reset_disk;
	__glow_set_function = __glow_set_default;
	
	neon_glow_intensity = 2;
	neon_glow_inner = 10;
	neon_glow_inner_mult = 22;
	
	disk_glow_radius = 256;
	disk_glow_quality = 5;
	disk_glow_intensity = 1;
	disk_glow_alpha = 0; //!
	disk_glow_gamma = .5;
	
	smoothing_type = SMOOTHING_GENTLE;
	smoothing_base_type = animcurve_get_channel(ac_smoothing, smoothing_type);
	static smoothing_secondary_type = animcurve_get_channel(ac_smoothing, "rapid2"); // change this to gentle for non-directional up&down wave motion mode //make static?
	secondary_noise_strength = .17; // jaggedness
	secondary_noise_density_multiplier = 2; // jaggedness
	start_point = _start_point;
	end_point = _end_point;
	segment_base = max(1, _segment); // segment length in pixels, aka "quality", bigger -> better performance
	density = .25; // Wave length, precision, quality
	height = 120; // Max wave height, in pixels // (amplitude)
	spd = -.1;
	turbulence = 3; // slow it down, change every other/3rd frame?
	
	width = 4; // line width/thickness
	color = #FFFFFF;
	outline_width = 0; // <- TODO
	outline_color = #D6007C;
	
	// Private variables, add _ ?
	is_parent = true;
	is_child = false;
	
	length = 0;
	angle = 0;
	num = -1;
	segment_real = 0;
	height_reduction = 0;
	points = []; // only populate points array if it's a parent, hmmm, but it will be too late as this will execute before we're changing is_parent to false, unless we pass is_parent as argument?
	__update_positional_data();
	
	noise_offset = random(10000); // (?) 500 seems enough, unsure what is the right value for this
	noise_secondary_offset = random(10000);
	
	is_parent = true; // if children_max is 0 set to false?
	is_child = false;
	recursion_level = 1;
	life = 0;
	
	child_chance = .10;
	child_life_min = 6; // In frames (hmmm, may be affected by reduced drawing mode?)
	child_life_max = 60; // Allow infinite life?
	children_max = 3;
	children = [];
	recursion_level_max = 2;
	static segments_num_min = 5; // Increase if you need more fluid movement at low lightning's lengths and short child lightnings
	static child_smoothing_type = SMOOTHING_GENTLE; // Seems to look the best regardless of base smoothing type
	child_length_min = 100; //? In pixels (could be % of starting/actual length?)
	child_length_max = infinity;
	child_cutoff_start = .0; // % of parent length
	child_cutoff_end = .0;
	
	static __spawn_child = function() {
		// Calculating start/end point index
		var child_segments_num_min = floor(child_length_min / segment_real);
		var max_delta = floor(child_length_max / segment_real) - child_segments_num_min;
		var cutoff_start = floor(child_cutoff_start * num);
		var cutoff_end = floor(child_cutoff_end * num);
		var p1_index = irandom_range(cutoff_start, num - cutoff_end - child_segments_num_min);
		var p2_start = p1_index + child_segments_num_min;
		var p2_index = irandom_range(p2_start, min(p2_start + max_delta, num - cutoff_end));
		
		var child_density = density;
		var child_height = height * .8;
		var child_spd = spd;
		var child_width = max(1, width - 2);
		var new_child = new Lightning(points[p1_index], points[p2_index], segment_base);
		// child height relative to it's length?
		// reduce alpha for children?
		new_child.height = child_height;
		new_child.spd = child_spd;
		new_child.width = child_width;
		new_child.density = child_density;
		new_child.color = color;
		new_child.recursion_level = recursion_level + 1;
		new_child.is_parent = (new_child.recursion_level <= recursion_level_max) ? true : false;
		new_child.is_child = true;
		new_child.life = irandom_range(child_life_min, child_life_max);
		new_child.turbulence = turbulence;
		new_child.outline_width = outline_width;
		new_child.smoothing_type = child_smoothing_type; // Could change to parent smoothing_type
		array_push(children, new_child);
	}
	
	static draw = function() {
		//noise_offset = random(500);
		
		var nx = start_point.x;
		var ny = start_point.y;	
		
		if (is_parent) points[0].update_position(nx, ny); // Updating start point here, because we're skipping i=0
		
		for (var i = 1; i <= num; i++) {
			var prev_x = nx;
			var prev_y = ny;
			
			var smoothing = animcurve_channel_evaluate(smoothing_base_type, (i)/(num));
			var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_type, (i)/(num));
			var x_offset = i * segment_real + random_range(-turbulence, turbulence) * smoothing_secondary;
			var base_noise = perlin_noise(noise_offset + x_offset * density, spd);
			var secondary_noise = perlin_noise(noise_secondary_offset + x_offset * density * secondary_noise_density_multiplier, spd); // add speed multiplier
			var y_offset = base_noise * height * height_reduction * smoothing + (secondary_noise * height * secondary_noise_strength + random_range(-turbulence, turbulence)) * smoothing_secondary;
			
			nx = start_point.x + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle + 90);
			ny = start_point.y + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle + 90);
			
			if (is_parent) points[i].update_position(nx, ny); // update only point indexes belonging to children? BUT how to check them and remove when needed?
			
			// outline_width = set_outline_width(_outline_width) -> outline_width = width + max(1, _outline_width / (recursion_level+1))
			if (outline_width > 0) draw_line_width_color(prev_x, prev_y, nx, ny, width + max(1, outline_width / (recursion_level)), outline_color, outline_color);
			draw_line_width_color(prev_x, prev_y, nx, ny, width, color, color);
		}
		
		// Taking care of babies
		if (is_parent) {
			
			// Conception
			if (random(1) < child_chance && 
				array_length(children) < children_max &&
				length * (1 - child_cutoff_start - child_cutoff_end) >= child_length_min) { // You need to be this tall to have a kid
				__spawn_child();
			}
			
			for (var k = array_length(children) - 1; k >= 0; k--) {
				var child = children[k];
				with (child) {
					
					// Deleting dead children or whos endpoint got deactivated; by extension, reference to their children is lost (right?)
					if (life <= 0 || end_point.active == false) { // end_point should be enough
						array_delete(other.children, array_get_index(other.children, self), 1);
						continue;
					}
					
					// Update children positional data (because their endpoints are constantly changing) & draw them 
					__update_positional_data();
					draw();
					life--; // ?dmode reminder
				}
			}
		}
	}
	
	static __update_positional_data = function() {
		// add check if points changed, if not, evacuate early?
		length = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		var prev_num = num;
		num = max(segments_num_min, floor(length / segment_base)); // Number of segments from start to end 
		segment_real = length / num; // In case given segment can't divide distance evenly, resize it
		height_reduction = (length > 50) ? 1 : (length / 100); // Reduce height for small distances
		
		// In case of parent, "resize" array of all points when distance changes
		if (is_parent) {
			
			// Add new points if lightning length increased, but not if array is long enough already
			if (prev_num < num && array_length(points) <= num) {
				var additional_points = array_create_ext((num - prev_num), function() { return new LPoint(0, 0); });
				points = array_concat(points, additional_points);
			}
			
			// Deactivate points (not delete) if lightning length decreased, so we can destroy children using them
			else if (prev_num > num) {
				for (var i = num; i <= prev_num; i++) {
					points[i].active = false;
				}
			}
		}
	}
	
	
	static glow_set = function() {
		__glow_set_function();
	}
	
	static glow_reset = function() {
		__glow_reset_function();
	}
	
	static update = function() {
		glow_set();
		draw();
		glow_reset();
	}
	
	static __glow_set_default = function() {
		// Setting up surfaces
		var _surf_width = camera_get_view_width(camera_get_active());
		var _surf_height = camera_get_view_height(camera_get_active());
		
		//var _surf_width = max(1, abs(start_point.x - end_point.x));
		//var _surf_height = max(1, abs(start_point.y - end_point.y));
		//surf_x = min(start_point.x, end_point.x);
		//surf_y = min(start_point.y, end_point.y);
		//trace($"{_surf_width} {_surf_height}");
		
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
		
		gpu_set_blendmode(bm_max);
	}
	
	static __glow_reset_neon = function() {
		surface_reset_target();
		var time = current_time;
		
		// Horizontal blur
		surface_set_target(surf_pass); {
			//draw_clear_alpha(c_black, 0); // why don't we need to clear this one? probably because of "gpu_set_blendenable(false)" later?
			
			shader_set(shd_blur_horizontal); {
				shader_set_uniform_f(uniform_blur_horizontal_glow, neon_glow_intensity, neon_glow_inner, neon_glow_inner_mult);
				shader_set_uniform_f(uniform_blur_horizontal_time, time); // rather subtle effect, but why not

				gpu_set_blendenable(false); // important!
				draw_surface(surf_base, 0, 0);
				gpu_set_blendenable(true);

			} shader_reset();
		} surface_reset_target();
		
		// Final drawing: Vertical blur (+ formely, Blending)
		
		shader_set(shd_blur_vertical); {
			shader_set_uniform_f(uniform_blur_vertical_glow, neon_glow_intensity, neon_glow_inner, neon_glow_inner_mult);
			shader_set_uniform_f(uniform_blur_vertical_time, time);
			draw_surface(surf_pass, 0, 0);
			
		} shader_reset();
		
		gpu_set_blendmode(bm_normal);
	}
	
	static __glow_reset_disk = function() {
		surface_reset_target();
		
		var _num = disk_glow_quality;
		var _mult = power(disk_glow_radius, 1 / _num);
		var _radius = _mult;
		var _colour = merge_colour(c_black, c_white, disk_glow_intensity); // Colour for glow intensity
		
		draw_surface_ext(surf_base, 0,0,1,1,0,-1, disk_glow_alpha);
		
		repeat(_num) {
			//Apply glow blur pass
			surface_set_target(surf_pass); {
			draw_clear(0);
				shader_set(shd_disk_glow);
					shader_set_uniform_f(uniform_disk_glow_texel_size, 1/surf_width, 1/surf_height);
					shader_set_uniform_f(uniform_disk_glow_radius, _radius);
					shader_set_uniform_f(uniform_disk_glow_gamma, disk_glow_gamma);
					draw_surface(surf_base, 0, 0);
				shader_reset();
			} surface_reset_target();

			draw_surface_ext(surf_pass, 0,0,1,1,0, _colour, 1);

			_radius *= -_mult;
			var _surf = surf_base;
			surf_base = surf_pass;
			surf_pass = _surf;
		}
		
		gpu_set_blendmode(bm_normal);
	}
	
	#region SETTERS
	
	static update_start = function(_x, _y) {
		start_point.x = _x;
		start_point.y = _y;
		__update_positional_data();
		return self;
	}
	
	static update_end = function(_x, _y) {
		end_point.x = _x;
		end_point.y = _y;
		__update_positional_data();
		return self;
	}
	
	static set_segment = function(_segment) {
		segment_base = max(1, _segment);
		__update_positional_data();
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
	
	static set_spd = function(_speed) {
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
	
	static set_outline_width = function(_outline_width) {
		outline_width = _outline_width;
		return self;
	}
	
	static set_smoothing_type = function(_smoothing_type) {
		smoothing_type = _smoothing_type;
		smoothing_base_type = animcurve_get_channel(ac_smoothing, smoothing_type);
		// Do not set for it's children
		return self;
	}
	
	// GLOW SETTERS
	
	static set_neon_glow_intensity = function(_neon_glow_intensity) {
		neon_glow_intensity = _neon_glow_intensity;
		return self;
	}
	
	static set_neon_glow_inner = function(_neon_glow_inner) {
		neon_glow_inner = _neon_glow_inner;
		return self;
	}
	
	static set_neon_glow_inner_mult = function(_neon_glow_inner_mult) {
		neon_glow_inner_mult = _neon_glow_inner_mult;
		return self;
	}
	
	static set_disk_glow_radius = function(_disk_glow_radius) {
		disk_glow_radius = _disk_glow_radius;
		return self;
	}
	
	static set_disk_glow_quality = function(_disk_glow_quality) {
		disk_glow_quality = _disk_glow_quality;
		return self;
	}
	
	static set_disk_glow_intensity = function(_disk_glow_intensity) {
		disk_glow_intensity = _disk_glow_intensity;
		return self;
	}
	
	static set_disk_glow_alpha = function(_disk_glow_alpha) {
		disk_glow_alpha = _disk_glow_alpha;
		return self;
	}
	
	static set_disk_glow_gamma = function(_disk_glow_gamma) {
		disk_glow_gamma = _disk_glow_gamma;
		return self;
	}
	
	static set_color = function(_color) {
		color = _color;
		
		// for smooth parameter changes that should affect children immediately, not just the newly created ones
		// TODO add to rest setters
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_color(color);
			}
		}
		return self;
	}
	
	static set_outline_color = function(_outline_color) {
		outline_color = _outline_color;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_outline_color(outline_color);
			}
		}
		return self;
	}
	
	static set_glow_type = function(_glow_type) {
		glow_type = _glow_type;
		switch (_glow_type) {
			case 0:
				// Set additive blendmode for drawing without any glow, so outlines don't go over main line
				__glow_set_function = function() { gpu_set_blendmode(bm_max); };
				__glow_reset_function = function() { gpu_set_blendmode(bm_normal); };
				break;
			case 1:
				__glow_set_function = __glow_set_default;
				__glow_reset_function = __glow_reset_neon;
				break;
			case 2:
				__glow_set_function = __glow_set_default;
				__glow_reset_function = __glow_reset_disk;
				break;
		}
		return self;
	}
	
	// CHILDREN SETTERS

	static set_child_chance = function(_child_chance) {
		child_chance = _child_chance;
		return self;
	}
	
	static set_child_life_min = function(_child_life_min) {
		child_life_min = min(_child_life_min, children_max); // Do not allow for min to be bigger than max?
		return self;
	}
	
	static set_child_life_max = function(_child_life_max) {
		child_life_max = max(0, _child_life_max);
		child_life_min = min(child_life_min, child_life_max);
		// Reduce the life to new max if it's currently too high
		life = min(life, child_life_max);
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_life_max(child_life_max);
			}
		}
		return self;
	}
	
	static set_children_max = function(_children_max) {
		children_max = max(0, _children_max);
		
		// Remove surpluss children
		if (array_length(children) > children_max) {
			array_resize(children, children_max);
		}
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_children_max(children_max);
			}
		}
		return self;
	}
	
	static set_recursion_level_max = function(_recursion_level_max) {
		recursion_level_max = max(1, _recursion_level_max);
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_recursion_level_max(recursion_level_max);
			}
		}
		return self;
	}
	
	static set_child_length_min = function(_child_length_min) {
		child_length_min = min(_child_length_min, child_length_max); // cut too long ones?
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_length_min(child_length_min);
			}
		}
		return self;
	}
	
	static set_child_length_max = function(_child_length_max) {
		child_length_max = max(1, _child_length_max);
		child_length_min = min(child_length_min, child_length_max);
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_length_max(child_length_max);
			}
		}
		return self;
	}
	
	static set_child_cutoff_start = function(_child_cutoff_start) {
		child_cutoff_start = clamp(_child_cutoff_start, 0, 1);
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_cutoff_start(child_cutoff_start);
			}
		}
		return self;
	}
	
	static set_child_cutoff_end = function(_child_cutoff_end) {
		child_cutoff_end = clamp(_child_cutoff_end, 0, 1);
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_cutoff_end(child_cutoff_end);
			}
		}
		return self;
	}
	
	#endregion
	
	// Freeing surfaces
	static cleanup = function() {
		// all instances are re-using same static surfaces so when are we supposed to call this?
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


function noop() {}


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


