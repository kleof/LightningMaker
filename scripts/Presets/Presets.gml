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
	defaults: {
		positions: global.handle_pos_vert_long,
		params: {
			segment : 12,
			density : .25,
			height : 120,
			spd : -.1,
			turbulence : 3,
			smoothing_type : SMOOTHING_GENTLE,
			
			line_width : 4,
			outline_width : 5,
			color : #FFFFFF,
			outline_color : #E90057,
			
			glow_type : GLOW_TYPE_DISK,
			
			neon_glow_intensity : 1.9,
			neon_glow_inner : 13.7,
			neon_glow_inner_mult : 21,
			
			disk_glow_radius : 256,
			disk_glow_quality : 5.5,
			disk_glow_intensity : 1,
			disk_glow_alpha : 1,
			disk_glow_gamma : .2,
			
			child_chance : .1,
			child_life_min : 6,
			child_life_max : 60,
			children_max : 3,
			recursion_level_max : 2,
			child_length_min: 100,
			child_length_max: 2000,
			child_cutoff_start: 0,
			child_cutoff_end: 0
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
		  "outline_color":9961489,
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
		  "glow_type":2.0,
		  "discokitty":false
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
		  "color":7947717,
		  "outline_width":4.0,
		  "outline_color":15269915,
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
		  "glow_type":1,
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
		  "color":18835,
		  "outline_width":10.0,
		  "outline_color":1769727,
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
		  "child_life_min":160.0,
		  "child_life_max":160.0,
		  "recursion_level_max":2.0,
		  "child_length_min":388.0,
		  "child_length_max":2000.0,
		  "child_cutoff_start":0.0,
		  "child_cutoff_end":0.0,
		  "glow_type":2,
		}
	},
	
	slow_wave: {
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
		  "child_life_min":275.0,
		  "child_life_max":275.0,
		  "child_length_min":201.0,
		  "child_length_max":2000.0,
		  "recursion_level_max":2.0,
		  "child_cutoff_start":0.05000000074505806,
		  "child_cutoff_end":0.05000000074505806,
		  "glow_type":2.0
		}
	},
	
}
	