#macro trace show_debug_message
//randomize();


// ***** DEFAULTS ***** //

start_handle = instance_create_layer(969, 85, "Thingies", obj_handle, {image_alpha: .3});
end_handle = instance_create_layer(587, 703, "Thingies", obj_handle, {image_alpha: .3});
params = {};

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
}
load_preset(PRESETS.pale_rose);


bolt = new Lightning(start_handle, end_handle);

// Stress test
//bolts = [];
//repeat (50) {
//	var _bolt = new Lightning(start_handle, end_handle);
//	array_push(bolts, _bolt);
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
dbg_button("RESET ALL", function() { load_preset(PRESETS.pale_rose) }, 230); dbg_same_line();
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
dbg_slider(ref_create(params, "child_length_min"), 1, 500, "Min child length", 1);
dbg_slider(ref_create(params, "child_length_max"), 1, 2000, "Max child length", 1);
dbg_slider(ref_create(params, "recursion_level_max"), 1, 10, "Max recursion level", 1);
dbg_slider(ref_create(params, "child_cutoff_start"), 0, 1, "Start cutoff", .05);
dbg_slider(ref_create(params, "child_cutoff_end"), 0, 1, "End cutoff", .05);

// EXAMPLES
dbg_text_separator("Examples");
dbg_button("Precise cut", function() { load_preset(PRESETS.precise_cut) }); dbg_same_line();
dbg_button("Toxic", function() { load_preset(PRESETS.toxic) });
dbg_button("Vampiric touch", function() { load_preset(PRESETS.vampiric_touch) }); dbg_same_line();
dbg_button("Abyssal wave", function() { load_preset(PRESETS.abyssal_wave) });
dbg_button("Cobweb", function() { load_preset(PRESETS.cobweb) }); dbg_same_line();
dbg_button("Plasma", function() { load_preset(PRESETS.plasma) });
dbg_button("Impulses", function() { load_preset(PRESETS.impulses) }); dbg_same_line();
dbg_button("Wild discharge", function() { load_preset(PRESETS.wild_discharge) });


dbg_text_separator("^. .^");
discokitty = false;
dbg_checkbox(ref_create(self, "discokitty"), "discokitty");
//dbg_slider(ref_create(params, "glow_type"), 0, 1, "---", .05);


// ~~~~~ CODE GENERATION ~~~~~ //

code_text = "";
generate_code = function() {
	var _names = struct_get_names(params);
	text = $"bolt = new Lightning(your_start_point, your_endpoint)\n";
	for (var i = 0; i < array_length(_names); i++) {
		var _name = _names[i];
		
		// Filter these words
		if ((params.glow_type == GLOW_TYPE_DISK || params.glow_type == GLOW_TYPE_NONE) && (string_pos("neon", _name) != 0)) continue;
		if ((params.glow_type == GLOW_TYPE_NEON || params.glow_type == GLOW_TYPE_NONE) && (string_pos("disk", _name) != 0)) continue;
		if ((string_pos("child_length_max", _name) != 0) && params[$ _name] >= 2000) { text += $".set_{_name}(infinity)\n"; continue; }
		
		text += $".set_{_name}({params[$ _name]})\n";
	}
	code_text = text;
}
copy_to_clipboard = function() {
	clipboard_set_text(code_text);
}

dbg_view("GENERATED CODE", true, 700, 640, 420, 200);
dbg_section("");
dbg_button("COPY CODE TO CLIPBOARD", copy_to_clipboard, 260);
dbg_text(ref_create(self, "code_text"));









