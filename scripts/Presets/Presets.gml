#macro PRESETS global.presets

global.handle_pos1 = {
	p1: {x:969, y:85},
	p2: {x:587, y:703}
}
global.handle_pos2 = {
	p1: {x:914, y:146},
	p2: {x:649, y:644}
}
global.handle_pos3 = {
	p1: {x:969, y:85},
	p2: {x:587, y:703}
}

PRESETS = {
	defaults: {
		positions: global.handle_pos2,
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
	
	blue_drain: {
		positions: global.handle_pos2,
		params: {
		  "segment":12.0,
		  "density":0.17000000178813934,
		  "spd":-0.029999999329447746,
		  "height":133.0,
		  "turbulence":0.0,
		  "smoothing_type":1.0,
		  "line_width":5.0,
		  "color":8455271,
		  "outline_width":9.0,
		  "outline_color":9243392,
		  "neon_glow_intensity":2.7999999523162842,
		  "neon_glow_inner":13.699999999999999,
		  "neon_glow_inner_mult":25.0,
		  "disk_glow_intensity":1.0,
		  "disk_glow_gamma":2.0,
		  "disk_glow_alpha":1.0,
		  "disk_glow_radius":256.0,
		  "disk_glow_quality":8.0,
		  "child_chance":0.5,
		  "children_max":3.0,
		  "child_life_min":275.0,
		  "child_life_max":275.0,
		  "recursion_level_max":2.0,
		  "child_length_min":201.0,
		  "child_length_max":2000.0,
		  "child_cutoff_start":0.05000000074505806,
		  "child_cutoff_end":0.05000000074505806,
		  "glow_type":2
		}
	},
	
}
	