
//*****     --_./\/\./``\__/`\/\.-->     *****//

/// @desc Function Description
/// @param {any*} start_point Starting point, can be anything with x,y attributes, like object instance, struct literal, etc
/// @param {any*} end_point Ending point, can be anything with x,y attributes, like object instance, struct literal, etc
/// @param {struct} [var_struct] [Optional] struct containing variables passed 
function Lightning(_start_point, _end_point, _var_struct={}) constructor {
	
	// Main variables
	start_point =	      _start_point;
	end_point =		      _end_point;
					      									  
	segment_base =	      _var_struct[$ "segment_base"]		   ?? 12;		// segment length in pixels, aka "quality"/"precision", bigger -> better performance
	density =		      _var_struct[$ "density"]			   ?? .25;		// Wave length
	height =		      _var_struct[$ "height"]			   ?? 120;		// Max wave height/amplitude, in pixels
	spd =			      _var_struct[$ "spd"]				   ?? -.1;
	turbulence =	      _var_struct[$ "turbulence"]		   ?? 3;
	line_width =	      _var_struct[$ "line_width"]		   ?? 4;
	color =			      _var_struct[$ "color"]			   ?? #FFFFFF;
	outline_width =       _var_struct[$ "outline_width"]	   ?? 5;
	outline_color =       _var_struct[$ "outline_color"]	   ?? #E90057;
	smoothing_type =      _var_struct[$ "smoothing_type"]      ?? SMOOTHING_GENTLE;
	static secondary_noise_strength = .17;			// kinda jaggedness, turbulence seems enough, static for now
	static secondary_noise_density_multiplier = 2;	// -//-
	
	child_chance =	      _var_struct[$ "child_chance"]		   ?? .1;
	child_life_min =      _var_struct[$ "child_life_min"]	   ?? 6;
	child_life_max =      _var_struct[$ "child_life_max"]	   ?? 60;		// Allow infinite life or big number will suffice?
	children_max =	      _var_struct[$ "children_max"]		   ?? 3;		
	child_length_min =    _var_struct[$ "child_length_min"]	   ?? 100;		// In pixels (could be % of starting/actual length?)
	child_length_max =    _var_struct[$ "child_length_max"]	   ?? infinity;
	recursion_level_max = _var_struct[$ "recursion_level_max"] ?? 2;
	child_cutoff_start =  _var_struct[$ "child_cutoff_start"]  ?? .0;		// % of parent length
	child_cutoff_end =    _var_struct[$ "child_cutoff_end"]	   ?? .0;		// % of parent length
	
	// Private variables
	is_parent =			  _var_struct[$ "is_parent"]		   ?? true;
	recursion_level =	  _var_struct[$ "recursion_level"]	   ?? 1;
	life =				  _var_struct[$ "life"]				   ?? 0;
	length = 0;
	angle = 0;
	num = -1;																// Number of segments from start to end 
	segment_real = 0;
	height_reduction = 1;
	points = [];
	children = [];
	
	smoothing_base_channel = animcurve_get_channel(ac_smoothing, smoothing_type);
	static smoothing_secondary_channel = animcurve_get_channel(ac_smoothing, "rapid2"); // change to gentle for non-directional up&down wave motion mode?
	static segments_num_min = 5;														// Increase if more fluid movement is needed at low lightning lengths
	static child_smoothing_type = SMOOTHING_GENTLE;										// Seems to look the best regardless of base smoothing type
	
	noise_offset = random(10000); // (?) 500 seems enough, unsure what is the right value for this
	noise_secondary_offset = random(10000);
	
	// Surfaces, shaders, glow settings
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
	
	neon_glow_intensity = 1.9;
	neon_glow_inner = 13.7;
	neon_glow_inner_mult = 21;
	
	disk_glow_radius = 256;
	disk_glow_quality = 5.5;
	disk_glow_intensity = 1;
	disk_glow_alpha = 1;
	disk_glow_gamma = .2;
	
	
	// DRAW THE LIGHTNING
	static draw = function() {
		
		__update_positional_data();
		var nx = start_point.x;
		var ny = start_point.y;	
		
		if (is_parent) points[0].update_position(nx, ny); // Updating start point here, because we're skipping i=0
		
		for (var i = 1; i <= num; i++) {
			var prev_x = nx;
			var prev_y = ny;
			
			var smoothing = animcurve_channel_evaluate(smoothing_base_channel, (i)/(num));
			var smoothing_secondary = animcurve_channel_evaluate(smoothing_secondary_channel, (i)/(num));
			var x_offset = i * segment_real + random_range(-turbulence, turbulence) * smoothing_secondary;
			var base_noise = perlin_noise(noise_offset + x_offset * density, spd);
			var secondary_noise = perlin_noise(noise_secondary_offset + x_offset * density * secondary_noise_density_multiplier, spd); // add speed multiplier?
			var y_offset = base_noise * height * height_reduction * smoothing + (secondary_noise * height * secondary_noise_strength + random_range(-turbulence, turbulence)) * smoothing_secondary;
			
			nx = start_point.x + lengthdir_x(x_offset, angle) + lengthdir_x(y_offset, angle + 90);
			ny = start_point.y + lengthdir_y(x_offset, angle) + lengthdir_y(y_offset, angle + 90);
			
			if (is_parent) points[i].update_position(nx, ny); // update only point indexes belonging to children? BUT how to check them and remove when needed?
			
			// Draw outline
			if (outline_width > 0) {
				var outline_adjusted = line_width + max(1, outline_width / recursion_level);
				draw_line_width_color(prev_x, prev_y, nx, ny, outline_adjusted, outline_color, outline_color);
			}
			
			// Draw main line
			draw_line_width_color(prev_x, prev_y, nx, ny, line_width, color, color);
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
					
					draw();
					life--;
				}
			}
		}
	}
	
	static __spawn_child = function() {
		
		// Calculating start/end point index
		var child_segments_num_min = floor(child_length_min / segment_real);
		var max_delta = floor(child_length_max / segment_real) - child_segments_num_min;
		var cutoff_start = floor(child_cutoff_start * num);
		var cutoff_end = floor(child_cutoff_end * num);
		var p1_index = irandom_range(cutoff_start, num - cutoff_end - child_segments_num_min);
		var p2_start = p1_index + child_segments_num_min;
		var p2_index = irandom_range(p2_start, min(p2_start + max_delta, num - cutoff_end));
		
		// Variables passed to child
		var var_struct = {
			segment_base,
			density,									// reduced for children could look alright
			spd,
			color,										// reduce alpha/darken color for children?
			outline_color,
			turbulence,
			outline_width,								// put outline calculations here, instead of draw method
			height:				height * .8,			// make child height relative to it's length? // for big heights bigger reduction looks better
			line_width:			max(1, line_width - 2), // add more ways of reduction
			smoothing_type:		child_smoothing_type,
			
			child_chance,
			child_life_min,
			child_life_max,
			children_max,
			child_length_min,
			child_length_max,
			recursion_level_max,
			child_cutoff_start,
			child_cutoff_end,
			
			recursion_level:	recursion_level + 1,
			is_parent:			(recursion_level + 1 <= recursion_level_max) ? true : false,
			life:				irandom_range(child_life_min, child_life_max),
		}
		var new_child = new Lightning(points[p1_index], points[p2_index], var_struct);
		//if (new_child.length < child_length_min) trace(new_child.length);
		
		array_push(children, new_child);
	}
	
	static __update_positional_data = function() {
		length = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		var prev_num = num;
		num = max(segments_num_min, floor(length / segment_base));
		segment_real = length / num;								// In case given segment can't divide distance evenly, resize it
		height_reduction = (length > 50) ? 1 : (length / 100);		// Reduce height for small lengths
		
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
	
	// SET THE SURFACES
	static glow_set = function() {
		__glow_set_function();
	}
	
	// APPLY SHADERS AND DRAW SURFACES
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
		
		gpu_push_state();
		surface_set_target(surf_base);
		draw_clear_alpha(c_black, 1);
		
		gpu_set_blendmode(bm_max);
	}
	
	static __glow_reset_neon = function() {
		surface_reset_target();
		var time = current_time;
		
		// Horizontal blur
		surface_set_target(surf_pass); {
			//draw_clear_alpha(c_black, 0);
			
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
		
		gpu_pop_state();
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
		
		gpu_pop_state();
	}
	
	
	// ===== SETTERS ===== //
	
	#region MAIN SETTERS
	
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
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_segment(segment_base);
			}
		}
		return self;
	}
	
	static set_density = function(_density) {
		density = _density;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_density(density);
			}
		}
		return self;
	}
	
	static set_height = function(_height) {
		height = _height;
		
		// skip children for now
		return self;
	}
	
	static set_spd = function(_speed) {
		spd = _speed;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_spd(spd);
			}
		}
		return self;
	}
	
	static set_line_width = function(_line_width) {
		line_width = _line_width;
		
		// skip children for now
		return self;
	}
	
	static set_turbulence = function(_turbulence) {
		turbulence = _turbulence;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_turbulence(turbulence);
			}
		}
		return self;
	}
	
	static set_outline_width = function(_outline_width) {
		outline_width = _outline_width;
		
		// get back to this later
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_outline_width(outline_width);
			}
		}
		return self;
	}
	
	static set_smoothing_type = function(_smoothing_type) {
		smoothing_type = _smoothing_type;
		smoothing_base_channel = animcurve_get_channel(ac_smoothing, smoothing_type);
		// Do not set for it's children
		return self;
	}
	
	static set_color = function(_color) {
		color = _color;
		
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
	#endregion
	
	#region GLOW SETTERS
	
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
	#endregion
	
	#region CHILDREN SETTERS

	static set_child_chance = function(_child_chance) {
		child_chance = _child_chance;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_chance(child_chance);
			}
		}
		return self;
	}
	
	static set_child_life_min = function(_child_life_min) {
		child_life_min = min(_child_life_min, children_max); // Do not allow for min to be bigger than max?
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_life_min(child_life_min);
			}
		}
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
		child_length_min = min(_child_length_min, child_length_max); // could add cutting too long ones
		
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
		
		// Being set = active
		active = true;
	}
}




