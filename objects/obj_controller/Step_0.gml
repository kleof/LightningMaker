if (discokitty) params.color = make_color_hsv((current_time*0.2 % 255), 255, 255);
params.child_life_min = min(params.child_life_min, params.child_life_max);
params.child_length_min = min(params.child_length_min, params.child_length_max);

generate_code();

bolt.set_density(params.density)
	.set_height(params.height)
	.set_spd(params.spd)
	.set_line_width(params.line_width)
	.set_segment(params.segment)
	.set_turbulence(params.turbulence)
	.set_outline_width(params.outline_width)
	.set_neon_glow_intensity(params.neon_glow_intensity)
	.set_neon_glow_inner(params.neon_glow_inner)
	.set_neon_glow_inner_mult(params.neon_glow_inner_mult)
	.set_color(params.color)
	.set_outline_color(params.outline_color)
	.set_disk_glow_alpha(params.disk_glow_alpha)
	.set_disk_glow_radius(params.disk_glow_radius)
	.set_disk_glow_quality(params.disk_glow_quality)
	.set_disk_glow_gamma(params.disk_glow_gamma)
	.set_disk_glow_intensity(params.disk_glow_intensity)
	.set_smoothing_type(params.smoothing_type)
	.set_child_chance(params.child_chance)
	.set_child_life_min(params.child_life_min)
	.set_child_life_max(params.child_life_max)
	.set_children_max(params.children_max)
	.set_recursion_level_max(params.recursion_level_max)
	.set_glow_type(params.glow_type)
	.set_child_length_min(params.child_length_min)
	.set_child_length_max(params.child_length_max)
	.set_child_cutoff_start(params.child_cutoff_start)
	.set_child_cutoff_end(params.child_cutoff_end)
	.set_blend_mode_add(params.blend_mode_add)
	.set_fade_out(params.fade_out)
	.set_fade_in(params.fade_in) // not ready
	.set_child_reduce_width(params.child_reduce_width)
	.set_child_reduce_alpha(params.child_reduce_alpha)

// crash button
//if (mouse_check_button_pressed(mb_left)) instance_destroy(start_handle);



