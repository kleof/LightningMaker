#macro PRESETS global.presets

global.handle_pos_vert_long = {
	p1: {x:969, y:85},
	p2: {x:587, y:703}
}
global.handle_pos_vert_short = {
	p1: {x:914, y:146},
	p2: {x:649, y:644}
}
global.handle_pos_vert_short_2 = {
	p1: {x:648, y:116},
	p2: {x:659, y:681}
}
global.handle_pos_hori = {
	p1: {x:524, y:173},
	p2: {x:1275, y:229}
}

PRESETS = {
	// BEAM EXAMPLES
	
	pale_rose: {
		positions: global.handle_pos_vert_long,
		params: {
			segment :		 LMD_SEGMENT,
			density :		 LMD_DENSITY,
			height : 		 LMD_HEIGHT,
			spd : 			 LMD_SPD,
			turbulence :	 LMD_TURBULENCE,
			smoothing_type : LMD_SMOOTHING_TYPE,
			
			line_width :	 LMD_LINE_WIDTH,
			outline_width :  LMD_OUTLINE_WIDTH,
			color :			 LMD_COLOR,
			outline_color :  LMD_OUTLINE_COLOR,
			
			secondary_noise_strength : LMD_SEC_NOISE_STRENGTH,
			secondary_noise_density_multiplier : LMD_SEC_NOISE_DENSITY_MULT,
			
			glow_type :		 LMD_GLOW_TYPE,
			blend_mode_add:  LMD_BLEND_MODE_ADD,
			
			neon_glow_intensity :	LMD_NEON_GLOW_INTENSITY,
			neon_glow_inner :		LMD_NEON_GLOW_INNER,
			neon_glow_inner_mult :  LMD_NEON_GLOW_INNER_MULT,
			
			disk_glow_radius :	  LMD_DISK_GLOW_RADIUS,
			disk_glow_quality :	  LMD_DISK_GLOW_QUALITY,
			disk_glow_intensity : LMD_DISK_GLOW_INTENSITY,
			disk_glow_alpha :	  LMD_DISK_GLOW_ALPHA,
			disk_glow_gamma :	  LMD_DISK_GLOW_GAMMA,
			
			child_chance :   LMD_CHILD_CHANCE,
			child_life_min : LMD_CHILD_LIFE_MIN,
			child_life_max : LMD_CHILD_LIFE_MAX,
			children_max :	 LMD_CHILDREN_MAX,
			recursion_level_max : LMD_RECURSION_LEVEL_MAX,
			child_length_min:     LMD_CHILD_LENGTH_MIN,
			child_length_max:     2000,
			child_cutoff_start:   LMD_CHILD_CUTOFF_START,
			child_cutoff_end:     LMD_CHILD_CUTOFF_END,
			fade_out:			  LMD_FADE_OUT,
			fade_out_speed:		  LMD_FADE_OUT_SPEED,
			fade_in:			  LMD_FADE_IN,
			fade_in_speed:		  LMD_FADE_IN_SPEED,
			child_reduce_width:   LMD_CHILD_REDUCE_WIDTH,
			child_reduce_alpha:   LMD_CHILD_REDUCE_ALPHA,
			
			// Strike Params
			duration:			  LMD_STRIKE_DURATION,
			end_points_max: 8
		}
	},
	
	wild_discharge: {
		positions: global.handle_pos_vert_short_2,
		params: {
		  "segment":12.0,
		  "density":0.25,
		  "spd":-0.11999999731779099,
		  "height":104.0,
		  "turbulence":3.0,
		  "smoothing_type":1.0,
		  "line_width":4.0,
		  "color":16777215.0,
		  "outline_width":5.0,
		  "outline_color":9961489.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.20000000000000001,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.30000001192092896,
		  "children_max":7.0,
		  "child_life_min":10.0,
		  "child_life_max":20.0,
		  "child_length_min":100.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":false,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":true,
		  "fade_in":false,
		  "fade_in_speed":2.5,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":2.0,
		}
	},
	
	cobweb: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":19.0,
		  "density":0.44999998807907104,
		  "spd":-0.10999999940395355,
		  "height":131.0,
		  "turbulence":3.0,
		  "smoothing_type":1.0,
		  "line_width":3.0,
		  "color":7947717.0,
		  "outline_width":4.0,
		  "outline_color":15269915.0,
		  "neon_glow_intensity":1.8999999761581421,
		  "neon_glow_inner":9.3000001907348633,
		  "neon_glow_inner_mult":22.299999237060547,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.20000000000000001,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.30000001192092896,
		  "children_max":5.0,
		  "child_life_min":53.0,
		  "child_life_max":123.0,
		  "child_length_min":100.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.20000000298023224,
		  "child_cutoff_end":0.20000000298023224,
		  "fade_out":false,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":false,
		  "fade_in_speed":2.5,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":1.0,
		}
	},
	
	vampiric_touch: {
		positions: global.handle_pos_vert_long,
		params: {
		  "segment":10.0,
		  "density":0.090000003576278687,
		  "spd":-0.05000000074505806,
		  "height":196.0,
		  "turbulence":0.0,
		  "smoothing_type":1.0,
		  "line_width":5.0,
		  "color":18835.0,
		  "outline_width":10.0,
		  "outline_color":1769727.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.20000000000000001,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.10000000000000001,
		  "children_max":3.0,
		  "child_life_min":120.0,
		  "child_life_max":160.0,
		  "child_length_min":388.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":true,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":true,
		  "fade_in_speed":1.8999999999999999,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":2.0,
		}
	},
	
	plasma: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":12.0,
		  "density":0.25,
		  "spd":-0.10000000000000001,
		  "height":120.0,
		  "turbulence":0.0,
		  "smoothing_type":1.0,
		  "line_width":5.0,
		  "color":6226135.0,
		  "outline_width":0.0,
		  "outline_color":16711739.0,
		  "neon_glow_intensity":2.2999999523162842,
		  "neon_glow_inner":8.3000001907348633,
		  "neon_glow_inner_mult":6.3000001907348633,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.20000000000000001,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.10000000000000001,
		  "children_max":3.0,
		  "child_life_min":6.0,
		  "child_life_max":60.0,
		  "child_length_min":100.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":false,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":false,
		  "fade_in_speed":10.0,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":1.0,
		}
	},
	
	impulses: {
		positions: global.handle_pos_vert_long,
		params: {
		  "segment":10.0,
		  "density":0.20000000298023224,
		  "spd":-0.029999999329447746,
		  "height":133.0,
		  "turbulence":2.0,
		  "smoothing_type":1.0,
		  "line_width":1.0,
		  "color":14580787.0,
		  "outline_width":0.0,
		  "outline_color":5701865.0,
		  "neon_glow_intensity":2.7999999523162842,
		  "neon_glow_inner":16.600000381469727,
		  "neon_glow_inner_mult":28.799999237060547,
		  "disk_glow_intensity":0.69999998807907104,
		  "disk_glow_gamma":0.69999998807907104,
		  "disk_glow_alpha":0.89999997615814209,
		  "disk_glow_radius":206.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.20000000298023224,
		  "children_max":3.0,
		  "child_life_min":6.0,
		  "child_life_max":18.0,
		  "child_length_min":100.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":false,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":false,
		  "fade_in_speed":10.0,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":1.0,
		}
	},
	
	toxic: {
		positions: global.handle_pos_vert_long,
		params: {
		  "segment":12.0,
		  "density":0.25,
		  "spd":-0.10000000000000001,
		  "height":120.0,
		  "turbulence":0.0,
		  "smoothing_type":0.0,
		  "line_width":3.0,
		  "color":2948864,
		  "outline_width":2.0,
		  "outline_color":65362,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.69999998807907104,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":248.0,
		  "disk_glow_quality":5.0,
		  "child_chance":0.32499998807907104,
		  "children_max":5.0,
		  "child_life_min":21.0,
		  "child_life_max":60.0,
		  "child_length_min":100.0,
		  "child_length_max":301.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":true,
		  "fade_out_speed":0.012000000104308128,
		  "child_reduce_width":true,
		  "child_reduce_alpha":true,
		  "fade_in":false,
		  "fade_in_speed":4.3000001907348633,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":true,
		  "glow_type":2.0,
		}
	},
	
	precise_cut: {
		positions: global.handle_pos_vert_long,
		params: {
		  "segment":12.0,
		  "density":0.25,
		  "spd":-0.27000001072883606,
		  "height":29.0,
		  "turbulence":0.0,
		  "smoothing_type":1.0,
		  "line_width":3.0,
		  "color":16777215.0,
		  "outline_width":5.0,
		  "outline_color":233.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.20000000000000001,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.10000000000000001,
		  "children_max":3.0,
		  "child_life_min":6.0,
		  "child_life_max":60.0,
		  "child_length_min":100.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":false,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":false,
		  "fade_in_speed":2.5,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":2.0,
		}
	},
	
	abyssal_wave: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":12.0,
		  "density":0.17000000178813934,
		  "spd":-0.029999999329447746,
		  "height":133.0,
		  "turbulence":0.0,
		  "smoothing_type":1.0,
		  "line_width":5.0,
		  "color":8455271.0,
		  "outline_width":9.0,
		  "outline_color":9243392.0,
		  "neon_glow_intensity":2.7999999523162842,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":25.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":2.0,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":197.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.5,
		  "children_max":3.0,
		  "child_life_min":75.0,
		  "child_life_max":275.0,
		  "child_length_min":201.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.05000000074505806,
		  "child_cutoff_end":0.05000000074505806,
		  "fade_out":true,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":true,
		  "fade_in":true,
		  "fade_in_speed":0.5,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":2.0,
		}
	},
	
	// STRIKE EXAMPLES
	rose: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":12.0,
		  "density":0.25,
		  "spd":-0.004999999888241291,
		  "height":120.0,
		  "turbulence":1.0,
		  "smoothing_type":1.0,
		  "line_width":4.0,
		  "color":16777215.0,
		  "outline_width":3.0,
		  "outline_color":5701865.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":1.1000000238418579,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":1.0,
		  "children_max":2.0,
		  "child_life_min":108.0,
		  "child_life_max":133.0,
		  "child_length_min":176.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":true,
		  "fade_out_speed":0.019999999552965164,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":true,
		  "fade_in_speed":2.4000000953674316,
		  "duration":60.0,
		  "secondary_noise_strength":0.079999998211860657,
		  "secondary_noise_density_multiplier":9.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":true,
		  "glow_type":2.0,
		}
	},
	
	spectre: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":12.0,
		  "density":0.14000000059604645,
		  "spd":0.02500000037252903,
		  "height":177.0,
		  "turbulence":1.0,
		  "smoothing_type":1.0,
		  "line_width":4.0,
		  "color":65366,
		  "outline_width":3.0,
		  "outline_color":6594048,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":1.5,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":1.0,
		  "children_max":5.0,
		  "child_life_min":108.0,
		  "child_life_max":133.0,
		  "child_length_min":176.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":true,
		  "fade_out_speed":0.017999999225139618,
		  "child_reduce_width":true,
		  "child_reduce_alpha":true,
		  "fade_in":true,
		  "fade_in_speed":0.80000001192092896,
		  "duration":93.0,
		  "secondary_noise_strength":0.14000000059604645,
		  "secondary_noise_density_multiplier":5.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":false,
		  "glow_type":2.0,
		}
	},
	
	snek: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":12.0,
		  "density":0.14000000059604645,
		  "spd":0.02500000037252903,
		  "height":177.0,
		  "turbulence":1.0,
		  "smoothing_type":1.0,
		  "line_width":4.0,
		  "color":65512.0,
		  "outline_width":3.0,
		  "outline_color":1370368.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":1.1000000238418579,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":1.0,
		  "children_max":2.0,
		  "child_life_min":108.0,
		  "child_life_max":133.0,
		  "child_length_min":176.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.20000000298023224,
		  "fade_out":true,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":true,
		  "fade_in_speed":2.4000000953674316,
		  "duration":60.0,
		  "secondary_noise_strength":0.18000000715255737,
		  "secondary_noise_density_multiplier":4.0,
		  "end_points_max":8.0,
		  "discokitty":false,
		  "blend_mode_add":true,
		  "glow_type":2.0,
		}
	},
	
	palpatine: { // speed/turb 0
		positions: global.handle_pos_hori,
		params: {
		  "segment":12.0,
		  "density":0.25,
		  "spd":-0.004999999888241291,
		  "height":120.0,
		  "turbulence":1.0,
		  "smoothing_type":1.0,
		  "line_width":4.0,
		  "color":16777215.0,
		  "outline_width":3.0,
		  "outline_color":15278592.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":1.5,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":1.0,
		  "children_max":5.0,
		  "child_life_min":108.0,
		  "child_life_max":133.0,
		  "child_length_min":176.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":true,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":true,
		  "fade_in":true,
		  "fade_in_speed":7.0999999046325684,
		  "duration":60.0,
		  "secondary_noise_strength":0.18000000715255737,
		  "secondary_noise_density_multiplier":4.0,
		  "end_points_max":10.0,
		  "blend_mode_add":false,
		  "discokitty":false,
		  "glow_type":2.0,
		}
	},
	
	goldi: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":8.0,
		  "density":0.14000000059604645,
		  "spd":-0.004999999888241291,
		  "height":120.0,
		  "turbulence":2.0,
		  "smoothing_type":1.0,
		  "line_width":2.0,
		  "color":16777215.0,
		  "outline_width":3.0,
		  "outline_color":44009,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":1.5,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":1.0,
		  "children_max":5.0,
		  "child_life_min":108.0,
		  "child_life_max":133.0,
		  "child_length_min":176.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.20000000298023224,
		  "fade_out":true,
		  "fade_out_speed":0.02,
		  "child_reduce_width":true,
		  "child_reduce_alpha":true,
		  "fade_in":true,
		  "fade_in_speed":6.9000000953674316,
		  "duration":60.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":7.0,
		  "end_points_max":8.0,
		  "blend_mode_add":true,
		  "discokitty":false,
		  "glow_type":2.0,
		}
	},
	
	drain: {
		positions: global.handle_pos_hori,
		params: {
		  "segment":13.0,
		  "density":0.090000003576278687,
		  "spd":0.035000000149011612,
		  "height":196.0,
		  "turbulence":0.0,
		  "smoothing_type":1.0,
		  "line_width":6.0,
		  "color":18835.0,
		  "outline_width":8.0,
		  "outline_color":1769727.0,
		  "neon_glow_intensity":1.8999999999999999,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":21.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":0.20000000000000001,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":5.5,
		  "child_chance":0.10000000000000001,
		  "children_max":3.0,
		  "child_life_min":120.0,
		  "child_life_max":160.0,
		  "child_length_min":388.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "fade_out":true,
		  "fade_out_speed":0.019999999552965164,
		  "child_reduce_width":true,
		  "child_reduce_alpha":false,
		  "fade_in":true,
		  "fade_in_speed":1.0,
		  "duration":121.0,
		  "secondary_noise_strength":0.17000000000000001,
		  "secondary_noise_density_multiplier":2.0,
		  "end_points_max":8.0,
		  "blend_mode_add":true,
		  "discokitty":false,
		  "glow_type":2.0,
		}
	},
}
