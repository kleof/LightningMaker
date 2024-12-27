//var color = make_color_hsv((current_time*0.2 % 255), 255, 255);
child_life_min = min(child_life_min, child_life_max);

bolt.update_start(start_handle.x, start_handle.y)
	.update_end(end_handle.x, end_handle.y)
	.set_density(density)
	.set_height(height)
	.set_speed(spd)
	.set_width(width)
	.set_segment(segment)
	.set_turbulence(turbulence)
	.set_outline_width(outline_width)
	.set_neon_glow_intensity(neon_glow_intensity)
	.set_neon_glow_inner(neon_glow_inner)
	.set_neon_glow_inner_mult(neon_glow_inner_mult)
	.set_color(color)
	.set_outline_color(outline_color)
	.set_disk_glow_alpha(disk_glow_alpha)
	.set_disk_glow_radius(disk_glow_radius)
	.set_disk_glow_quality(disk_glow_quality)
	.set_disk_glow_gamma(disk_glow_gamma)
	.set_disk_glow_intensity(disk_glow_intensity)
	.set_smoothing_type(smoothing_type)
	.set_child_chance(child_chance)
	.set_child_life_min(child_life_min)
	.set_child_life_max(child_life_max)
	.set_children_max(children_max)






