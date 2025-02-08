// METHODS


// Presets loading

load_preset = function(_preset) {
	var names = struct_get_names(_preset.params);
	for (var i = 0; i < array_length(names); i++) {
		var name = names[i];
		params[$ name] = _preset.params[$ name];
	}
	start_handle.x = _preset.positions.p1.x;
	start_handle.y = _preset.positions.p1.y;
	end_handle.x = _preset.positions.p2.x;
	end_handle.y = _preset.positions.p2.y;
	
	if (struct_exists(self, "bolt")) set_all_bolt_params();
}

load_preset_strike = function(_preset) { 
	bolt.set_fade_in(false);
	load_preset(_preset);
	strike_random();
}


// ***** DEBUG FUNCTIONS ***** //

activate_disk_mode = function() {
	params.glow_type = GLOW_TYPE_DISK;
}
activate_neon_mode = function() {
	params.glow_type = GLOW_TYPE_NEON;
}
activate_none_mode = function() {
	params.glow_type = GLOW_TYPE_NONE;
}

load_disk_mode_defaults = function() {
	params.glow_type = GLOW_TYPE_DISK;
	params.line_width = 4;
	params.color = #FFFFFF;
	params.outline_color = #E90057;
	params.outline_width = 5;
}
load_neon_mode_defaults = function() {
	params.glow_type = GLOW_TYPE_NEON;
	params.line_width = 6;
	params.color = 6226135;
	params.outline_width = 0;
}


// LIGHTNING CONTROL

strike_random = function() {
	start_handle.x = 450;
	start_handle.y = 600;
	end_handle.x = 450;
	end_handle.y = 700;
	
	thunder.set_template(bolt);
	
	var _x = random_range(700, 1100);
	var _collateral = [];
	repeat (irandom(params.end_points_max)) { // add param for that
		array_push(_collateral, new LPoint(_x + random_range(-200, 200), 703));
	}
	
	thunder.strike(_x, 85, _x + random_range(-100, 100), 703, params.duration, , _collateral);
}

set_all_bolt_params = function() {
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
	.set_fade_in(params.fade_in)
	.set_child_reduce_width(params.child_reduce_width)
	.set_child_reduce_alpha(params.child_reduce_alpha)
	.set_fade_in_speed(params.fade_in_speed)
	.set_secondary_noise_strength(params.secondary_noise_strength)
	.set_secondary_noise_density_multiplier(params.secondary_noise_density_multiplier)
	.set_fade_out_speed(params.fade_out_speed)
}




