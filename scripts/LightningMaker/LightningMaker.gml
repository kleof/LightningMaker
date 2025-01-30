
//*****     --_./\/\./``\__/`\/\.-->     *****//

/// @desc Creates new lightning
/// @param {any*} start_point Starting point, can be anything with x,y attributes, like object instance, struct literal, etc
/// @param {any*} end_point Ending point, can be anything with x,y attributes, like object instance, struct literal, etc
/// @param {any*} collateral [Optional] array of points (instances, structs, etc) that can be hit by child lightnings
function Lightning(_start_point, _end_point, _collateral=[]) constructor {
	
	// Main variables
	start_point =	       _start_point;
	end_point =			   _end_point;
	collateral =		   _collateral;
	array_foreach(collateral, function(element) { element.__active = true; });
	start_point[$ "__drawn"] ??= true;
	
	segment_base =	       LMD_SEGMENT;										// segment length in pixels, aka quality/precision, bigger -> better performance (CPU)
	density =		       LMD_DENSITY;										// Wave length
	height =		       LMD_HEIGHT;										// Max wave height/amplitude, in pixels
	spd =			       LMD_SPD;
	turbulence =	       LMD_TURBULENCE;
	line_width =	       LMD_LINE_WIDTH;
	color =			       LMD_COLOR;
	outline_width =        LMD_OUTLINE_WIDTH;
	outline_color =        LMD_OUTLINE_COLOR;
	smoothing_type =       LMD_SMOOTHING_TYPE;
	static secondary_noise_strength =			LMD_SEC_NOISE_STRENGTH;		// kinda jaggedness, turbulence seems enough, static for now
	static secondary_noise_density_multiplier = LMD_SEC_NOISE_DENSITY_MULT;	// -//-
	
	child_chance =	       LMD_CHILD_CHANCE;								// chance to spawn child every frame
	child_life_min =       LMD_CHILD_LIFE_MIN;						
	child_life_max =       LMD_CHILD_LIFE_MAX;						
	children_max =	       LMD_CHILDREN_MAX;						
	child_length_min =     LMD_CHILD_LENGTH_MIN;							// In pixels (could be % of starting/actual length?), accuracy depends on segment base length
	child_length_max =     LMD_CHILD_LENGTH_MAX;
	recursion_level_max =  LMD_RECURSION_LEVEL_MAX;
	child_cutoff_start =   LMD_CHILD_CUTOFF_START;							// % of parent length, (applies only to main and not children)
	child_cutoff_end =     LMD_CHILD_CUTOFF_END;							// % of parent length
	fade_out =			   LMD_FADE_OUT;
	fade_in =			   LMD_FADE_IN;
	fade_in_speed =		   2.5;
	child_reduce_width =   LMD_CHILD_REDUCE_WIDTH;								// Should children be thinner
	child_reduce_alpha =   LMD_CHILD_REDUCE_ALPHA;
	static fade_speed =	   0.02;
	static fade_start =    floor(1 / fade_speed);
	
	glow_type =			   LMD_GLOW_TYPE;
	blend_mode_add =	   LMD_BLEND_MODE_ADD;
	neon_glow_intensity =  LMD_NEON_GLOW_INTENSITY;
	neon_glow_inner =	   LMD_NEON_GLOW_INNER;
	neon_glow_inner_mult = LMD_NEON_GLOW_INNER_MULT;
	disk_glow_radius =	   LMD_DISK_GLOW_RADIUS;
	disk_glow_quality =	   LMD_DISK_GLOW_QUALITY;							// lower -> better performance (GPU)
	disk_glow_intensity =  LMD_DISK_GLOW_INTENSITY;
	disk_glow_alpha =      LMD_DISK_GLOW_ALPHA;
	disk_glow_gamma =      LMD_DISK_GLOW_GAMMA;
	
	// Private variables
	is_parent =	true;
	recursion_level = 1;
	outline_adjusted = line_width + max(1 + floor(line_width/3), outline_width / recursion_level);
	life = infinity;
	alpha = 1;
	length = 0;
	angle = 0;
	num = -1;										// Number of segments from start to end 
	segment_real = 0;								// Recalculated segment length
	height_reduction = 1;							// hight reduction for small lengths, may be unnecessary
	points = [];
	children = [];
	draw_alpha = (fade_out || fade_in || child_reduce_alpha);
	points_drawn = 0;
	
	smoothing_base_channel = animcurve_get_channel(ac_smoothing, smoothing_type);
	static smoothing_secondary_channel = animcurve_get_channel(ac_smoothing, "rapid2"); // change to gentle for non-directional up&down wave motion mode?
	static segments_num_min = 5;														// Increase if more fluid movement is needed at low lightning lengths
	static child_smoothing_type = SMOOTHING_GENTLE;										// Seems to look the best regardless of base smoothing type
	
	noise_offset = random(10000); // (?) 500 seems enough, unsure what is the right value for this
	noise_secondary_offset = random(10000);
	
	// Surfaces, shaders
	surf_base = -1;
	surf_pass = -1;
	surf_width = 1;
	surf_height = 1;
	static uniform_blur_horizontal_glow = shader_get_uniform(shd_blur_horizontal, "u_glowProperties");
	static uniform_blur_horizontal_time = shader_get_uniform(shd_blur_horizontal, "u_time");
	static uniform_blur_vertical_glow = shader_get_uniform(shd_blur_vertical, "u_glowProperties");
	static uniform_blur_vertical_time = shader_get_uniform(shd_blur_vertical, "u_time");
	static uniform_disk_glow_radius = shader_get_uniform(shd_disk_glow, "g_GlowRadius");
	static uniform_disk_glow_gamma = shader_get_uniform(shd_disk_glow, "g_GlowGamma");
	static uniform_disk_glow_texel_size  = shader_get_uniform(shd_disk_glow, "gm_pSurfaceTexelSize");
	
	
	// DRAW THE LIGHTNING
	static draw = function() {
		if (start_point.__drawn == true) points_drawn += fade_in_speed;
		
		__update_positional_data();
		var nx = start_point.x;
		var ny = start_point.y;	
		
		if (is_parent) points[0].update_position(nx, ny); // Updating start point here, because we're skipping i=0
		if (draw_alpha) {
			draw_set_alpha(alpha);
			if (fade_out && life < fade_start) alpha -= fade_speed;
		}
		
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
			
			if (i > points_drawn) continue;
			if (is_parent) points[i].__drawn = true;
			// Draw outline
			if (outline_width > 0) {
				draw_line_width_color(prev_x, prev_y, nx, ny, outline_adjusted, outline_color, outline_color);
			}
			
			// Draw main line
			draw_line_width_color(prev_x, prev_y, nx, ny, line_width, color, color);
		}
		
		if (draw_alpha) draw_set_alpha(1); // reload saved one?
		
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
					if (life <= 0 || end_point.__active == false || start_point.__active == false) {
						array_delete(other.children, array_get_index(other.children, self), 1);
						continue;
					}
					
					draw();
				}
			}
		}
		
		// Reduce life
		life--;
	}
	
	static __spawn_child = function() {
		
		// Calculating start/end point index
		var child_segments_num_min = ceil(child_length_min / segment_real);
		var max_delta = floor(child_length_max / segment_real) - child_segments_num_min;
		var cutoff_start = floor(child_cutoff_start * num);
		var cutoff_end = floor(child_cutoff_end * num);
		var p1_index = irandom_range(cutoff_start, num - cutoff_end - child_segments_num_min);
		var p1 = points[p1_index];
		var p2_index, p2;
		
		var collateral_length = array_length(collateral);
		if (collateral_length > 0 && random(1) < .8) {
			p2 = collateral[irandom(collateral_length - 1)];
		} else {
			var p2_start = p1_index + child_segments_num_min;
			p2_index = irandom_range(p2_start, min(p2_start + max_delta, num - cutoff_end));
			p2 = points[p2_index];
		}
		
		var new_child = new Lightning(p1, p2, collateral);
		
		// Variables passed to child
		new_child.segment_base			= segment_base;
		new_child.density				= density;														// reduced for children could look alright
		new_child.spd					= spd;
		new_child.line_width			= (child_reduce_width) ? max(1, line_width - 2) : line_width;	// Warning: formula is in set_ method as well
		new_child.color					= color;
		new_child.outline_color			= outline_color;												
		new_child.turbulence			= turbulence;													
		new_child.height				= height * .8;													// make child height relative to it's length? // for big heights bigger reduction looks better
		new_child.smoothing_type		= child_smoothing_type;
		
		new_child.child_chance			= child_chance;	
		new_child.child_life_min		= child_life_min;	
		new_child.child_life_max		= child_life_max;	
		new_child.children_max			= children_max;	
		new_child.child_length_min		= child_length_min;	
		new_child.child_length_max		= child_length_max;	
		new_child.recursion_level_max	= recursion_level_max;
		new_child.child_reduce_width	= child_reduce_width;
		new_child.child_reduce_alpha	= child_reduce_alpha;
		new_child.fade_out				= fade_out;
		new_child.fade_in				= fade_in;
		//new_child.child_cutoff_start	= 0;															// Not applying it to children
		//new_child.child_cutoff_end	= 0;															// -//-
		
		new_child.recursion_level		= recursion_level + 1;
		new_child.set_outline_width(outline_width);														// this sets adjusted_outline as well
		new_child.is_parent				= (recursion_level + 1 <= recursion_level_max) ? true : false;
		new_child.life					= min(life, irandom_range(child_life_min, child_life_max));
		new_child.alpha					= (child_reduce_alpha) ? min(alpha, random_range(.2, alpha-.1)) : alpha;
		
		new_child.__set_draw_alpha();
		
		array_push(children, new_child);
	}
	
	static __update_positional_data = function() {
		length = point_distance(start_point.x,start_point.y, end_point.x,end_point.y);
		angle = point_direction(start_point.x,start_point.y, end_point.x,end_point.y);
		var prev_num = num;
		num = max(segments_num_min, floor(length / segment_base));
		segment_real = length / num;								// In case given segment can't divide distance evenly, resize it
		height_reduction = (length > 50) ? 1 : (length / 100);
		
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
					points[i].__active = false;
				}
			}
		}
	}
	
	glow_set = __glow_set_default;	// SET THE SURFACES
	glow_reset = __glow_reset_disk;	// APPLY SHADERS AND DRAW SURFACES
	
	// ALL IN ONE
	static update = function() {
		glow_set();
		draw();
		glow_reset();
	}
	
	// DEFAULT SURFACE SETUP
	static __glow_set_default = function() {
		// Setting up surfaces
		var _camera = view_camera[0];
		var _surf_width = camera_get_view_width(_camera);
		var _surf_height = camera_get_view_height(_camera);

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
			camera_apply(_camera);
			
			draw_clear_alpha(c_black, 1);
			if (draw_alpha || blend_mode_add) gpu_set_blendmode(bm_add); // bm_add is required for proper alpha blending
			else gpu_set_blendmode(bm_max);
	}
	
	// NEON GLOW
	static __glow_reset_neon = function() {
		surface_reset_target();
		
		var _camera = view_camera[0];
		var _cam_x = camera_get_view_x(_camera);
		var _cam_y = camera_get_view_y(_camera);
		var time = current_time;
		
		// Horizontal blur
		surface_set_target(surf_pass); {
			camera_apply(_camera);
			//draw_clear_alpha(c_black, 0);
			
			shader_set(shd_blur_horizontal); {
				shader_set_uniform_f(uniform_blur_horizontal_glow, neon_glow_intensity, neon_glow_inner, neon_glow_inner_mult);
				shader_set_uniform_f(uniform_blur_horizontal_time, time); // rather subtle effect, but why not

				gpu_set_blendenable(false); // important!
				draw_surface(surf_base, _cam_x, _cam_y);
				gpu_set_blendenable(true);

			} shader_reset();
		} surface_reset_target();
		
		// Final drawing, Vertical blur // (+ formely, blending)
		shader_set(shd_blur_vertical); {
			shader_set_uniform_f(uniform_blur_vertical_glow, neon_glow_intensity, neon_glow_inner, neon_glow_inner_mult);
			shader_set_uniform_f(uniform_blur_vertical_time, time);
			draw_surface(surf_pass, _cam_x, _cam_y);
			
		} shader_reset();
		
		gpu_pop_state();
	}
	
	// DISK GLOW
	static __glow_reset_disk = function() {
		surface_reset_target();
		
		if (blend_mode_add == false && draw_alpha == true) gpu_set_blendmode(bm_max); // If we drew with alpha (but don't want bm_add for glow effect) we go back to bm_max
		
		var _camera = view_camera[0];
		var _cam_x = camera_get_view_x(_camera);
		var _cam_y = camera_get_view_y(_camera);
		
		var _num = disk_glow_quality;
		var _mult = power(disk_glow_radius, 1 / _num);
		var _radius = _mult;
		var _colour = merge_colour(c_black, c_white, disk_glow_intensity); // Colour for glow intensity
		
		draw_surface_ext(surf_base, _cam_x,_cam_y,1,1,0,-1, disk_glow_alpha);
		
		repeat(_num) {
			//Apply glow blur pass
			surface_set_target(surf_pass); {
				camera_apply(_camera);
				draw_clear(0);
				shader_set(shd_disk_glow);
					shader_set_uniform_f(uniform_disk_glow_texel_size, 1/surf_width, 1/surf_height);
					shader_set_uniform_f(uniform_disk_glow_radius, _radius);
					shader_set_uniform_f(uniform_disk_glow_gamma, disk_glow_gamma);
					draw_surface(surf_base, _cam_x,_cam_y);
				shader_reset();
			} surface_reset_target();

			draw_surface_ext(surf_pass, _cam_x,_cam_y,1,1,0, _colour, 1);

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
	
	static set_collateral = function(_collateral) {
		collateral = _collateral;
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
		set_outline_width(outline_width);
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_line_width((child_reduce_width) ? max(1, line_width - 2) : line_width);
			}
		}
		return self;
	}
	
	static set_outline_width = function(_outline_width) {
		outline_width = _outline_width;
		var _recursion = (child_reduce_width) ? recursion_level : 1;
		outline_adjusted = line_width + max(1 + floor(line_width/3), outline_width / _recursion);
		
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
		// Do not set for children
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
	
	static set_turbulence = function(_turbulence) {
		turbulence = _turbulence;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_turbulence(turbulence);
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
			case GLOW_TYPE_NONE:
				// Set additive blendmode for drawing without any glow, so children outlines don't go over main line
				glow_set = function() { gpu_set_blendmode(bm_max); };
				glow_reset = function() { gpu_set_blendmode(bm_normal); };
				break;
			case GLOW_TYPE_NEON:
				glow_set = __glow_set_default;
				glow_reset = __glow_reset_neon;
				break;
			case GLOW_TYPE_DISK:
				glow_set = __glow_set_default;
				glow_reset = __glow_reset_disk;
				break;
		}
		return self;
	}
	
	static set_blend_mode_add = function(_enable) {
		blend_mode_add = _enable;
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
		child_life_min = min(_child_life_min, child_life_max); // Do not allow for min to be bigger than max?
		
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
		
		if (is_parent) {
			// Reduce the life if it's currently too high
			var child_life = min(life, child_life_max);
			
			for (var i = 0; i < array_length(children); i++) {
				var child = children[i];
				child.set_child_life_max(child_life_max);
				child.life = min(child_life, child.life);
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
	
	static set_fade_out = function(_enable) {
		fade_out = _enable;
		__set_draw_alpha();
		return self;
	}
	
	static set_fade_in = function(_enable) {
		fade_in = _enable;
		__set_draw_alpha();
		return self;
	}
	
	static set_child_reduce_width = function(_enable) {
		child_reduce_width = _enable;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_reduce_width(_enable);
			}
		}
		return self;
	}
	
	static set_child_reduce_alpha = function(_enable) {
		child_reduce_alpha = _enable;
		
		if (is_parent) {
			for (var i = 0; i < array_length(children); i++) {
				children[i].set_child_reduce_alpha(_enable);
			}
		}
		return self;
	}
	#endregion
	
	static __set_draw_alpha = function() {
		draw_alpha = (fade_out || fade_in || child_reduce_alpha);
	}
	
	// Freeing surfaces
	static cleanup = function() {
		// when to call this?
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
	__active = true;
	__drawn = false;
	
	static update_position = function(_x, _y) {
		x = _x;
		y = _y;
		
		// Being set = active
		__active = true;
	}
}




