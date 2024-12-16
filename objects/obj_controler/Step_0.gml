bolt.update_start(start_handle.x, start_handle.y)
	.update_end(end_handle.x, end_handle.y)
	.set_density(density)
	.set_height(height)
	.set_speed(spd)
	.set_width(width)
	.set_segment(segment)
	.set_turbulence(turbulence)





layer_set_visible("effect_glow", fx_glow_enabled);
fx_set_parameter(fx_outline, "g_OutlineRadius", fx_outline_width);
fx_set_parameter(fx_outline, "g_OutlineColour", color_to_array(fx_outline_color));
