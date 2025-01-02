#macro trace show_debug_message
//randomize();

// ***** DEFAULTS ***** //

start_handle = instance_create_layer(969, 85, "Thingies", obj_handle, {image_alpha: .3});
end_handle = instance_create_layer(587, 703, "Thingies", obj_handle, {image_alpha: .3});

load_all_defaults = function() {
	params = {
		segment : 12,
		density : .25,
		height : 120,
		spd : -.1,
		line_width : 4,
		outline_width : 5,
		color : #FFFFFF,
		outline_color : #E90057,
		turbulence : 3,
		smoothing_type : SMOOTHING_GENTLE,
		
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
}
load_all_defaults();

// ***** CREATE LIGHTNING ***** //

bolt = new Lightning(start_handle, end_handle, params.segment);

//bolts = [];
//repeat (50) {
//	var bolt = new Lightning(start_point, end_point, segment);
//	array_push(bolts, bolt);
//}

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

// ***** DEBUG PANEL ***** //

dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 450, 750); // what's up with sliders input btw? >.>
dbg_section("Main Properties");
dbg_button("RESET ALL", load_all_defaults, 230); dbg_same_line();
dbg_button("Turn OFF Glow", activate_none_mode);

// MAIN
dbg_slider(ref_create(params, "segment"), 1, 80, "Segment", 1);
dbg_slider(ref_create(params, "density"), 0, 1, "Density", .01);
dbg_slider(ref_create(params, "spd"), -.7, 0, "Speed", .01);
dbg_slider(ref_create(params, "height"), 10, 300, "Height", 1);
dbg_slider(ref_create(params, "turbulence"), 0, 20, "Turbulence", 1);
dbg_drop_down(ref_create(params, "smoothing_type"), "Rapid:0,Gentle:1,Sine:2,Rapid2:3,OpenEnd:4", "Endpoints smoothing");

// LINES & COLOR
dbg_text_separator("Line");
dbg_slider(ref_create(params, "line_width"), 1, 18, "Line width", 1);
dbg_colour(ref_create(params, "color"), "Main color");
dbg_slider(ref_create(params, "outline_width"), 0, 20, "Outline width", 1);
dbg_colour(ref_create(params, "outline_color"), "Outline color");

// NEON GLOW
dbg_text_separator("Neon Glow Settings");
dbg_button("Load \"Neon Glow\" line defaults", load_neon_mode_defaults, 230); dbg_same_line();
dbg_button("Turn it ON only", activate_neon_mode);
dbg_slider(ref_create(params, "neon_glow_intensity"), 0, 5, "Outer intensity", .1);
dbg_slider(ref_create(params, "neon_glow_inner"), 0, 40, "Inner intensity", .1);
dbg_slider(ref_create(params, "neon_glow_inner_mult"), 0, 40, "Inner multiplier", .1);

// DISK GLOW
dbg_text_separator("Disk Glow Settings");
dbg_button("Load \"Disk Glow\" line defaults", load_disk_mode_defaults, 230); dbg_same_line();
dbg_button("Turn it ON only", activate_disk_mode);
dbg_slider(ref_create(params, "disk_glow_intensity"), 0, 1, "Intensity", .1);
dbg_slider(ref_create(params, "disk_glow_gamma"), 0, 2, "Gamma", .1);
dbg_slider(ref_create(params, "disk_glow_alpha"), 0, 1, "Alpha", .1);
dbg_slider(ref_create(params, "disk_glow_radius"), 1, 1024, "Radius", 1);
dbg_slider(ref_create(params, "disk_glow_quality"), 3, 10, "Quality", .5);

// CHILDREN
dbg_text_separator("Children Settings");
dbg_slider(ref_create(params, "child_chance"), 0, 1, "Child chance", .05);
dbg_slider(ref_create(params, "children_max"), 0, 15, "Max children amount", 1);
dbg_slider(ref_create(params, "child_life_min"), 0, 300, "Min child life", 1);
dbg_slider(ref_create(params, "child_life_max"), 0, 300, "Max child life", 1);
dbg_slider(ref_create(params, "recursion_level_max"), 1, 10, "Max recursion level", 1);
dbg_slider(ref_create(params, "child_length_min"), 1, 500, "Min child length", 1);
dbg_slider(ref_create(params, "child_length_max"), 1, 2000, "Max child length", 1);
dbg_slider(ref_create(params, "child_cutoff_start"), 0, 1, "Start cutoff", .05);
dbg_slider(ref_create(params, "child_cutoff_end"), 0, 1, "End cutoff", .05);


// ~~~~~ CODE GENERATION ~~~~~ //

code_text = "";
generate_code = function() {
	var _names = struct_get_names(params);
	text = $"bolt = new Lightning(your_start_point, your_endpoint, {params.segment})\n";
	for (var i = 0; i < array_length(_names); i++) {
		var _name = _names[i];
		
		// Filter these words
		if ((params.glow_type == GLOW_TYPE_DISK || params.glow_type == GLOW_TYPE_NONE) && (string_pos("neon", _name) != 0)) continue;
		if ((params.glow_type == GLOW_TYPE_NEON || params.glow_type == GLOW_TYPE_NONE) && (string_pos("disk", _name) != 0)) continue;
		if (string_pos("segment", _name) != 0) continue;
		
		text += $".set_{_name}({params[$ _name]})\n";
	}
	code_text = text;
}
copy_to_clipboard = function() {
	clipboard_set_text(code_text);
}

dbg_view("GENERATED CODE", true, 910, 530, 450, 200);
dbg_section("");
dbg_button("COPY CODE TO CLIPBOARD", copy_to_clipboard, 260);
dbg_text(ref_create(self, "code_text"));









