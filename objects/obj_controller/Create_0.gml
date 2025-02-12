#macro trace show_debug_message
//randomize();
// LOAD METHODS
event_user(15);

// ***** DEFAULTS ***** //

start_handle = instance_create_layer(969, 85, "Thingies", obj_handle, {image_alpha: .3});
end_handle = instance_create_layer(587, 703, "Thingies", obj_handle, {image_alpha: .3});
//handle3 = instance_create_layer(500, 720, "Thingies", obj_handle, {image_alpha: .3});
//handle4 = instance_create_layer(540, 720, "Thingies", obj_handle, {image_alpha: .3});
//handle5 = instance_create_layer(580, 720, "Thingies", obj_handle, {image_alpha: .3});
params = {};


load_preset(PRESETS.pale_rose);

bolt = new Lightning(start_handle, end_handle);
thunder = new LightningStrike(bolt);

//bolt = new Lightning(start_handle, end_handle, [handle3, handle4, handle5]);

// Stress test
//bolts = [];
//repeat (50) {
//	var _bolt = new Lightning(start_handle, end_handle);
//	array_push(bolts, _bolt);
//}


// ***** DEBUG PANEL ***** //

dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 450, 750); // what's up with sliders input btw? >.>
dbg_section("Main Properties");
dbg_button("RESET ALL", function() { load_preset(PRESETS.pale_rose) }, 230); dbg_same_line();
dbg_button("Turn OFF Glow", activate_none_mode);

// MAIN
dbg_slider(ref_create(params, "segment"), 1, 80, "Segment", 1);
dbg_slider(ref_create(params, "density"), 0, 1, "Density", .01);
dbg_slider(ref_create(params, "spd"), -.7, 0, "Speed", .005);
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
dbg_slider(ref_create(params, "child_chance"), 0, 1, "Child chance", .025);
dbg_slider(ref_create(params, "children_max"), 0, 15, "Max children amount", 1);
dbg_slider(ref_create(params, "child_life_min"), 1, 300, "Min child life", 1);
dbg_slider(ref_create(params, "child_life_max"), 1, 300, "Max child life", 1);
dbg_slider(ref_create(params, "child_length_min"), 1, 500, "Min child length", 1);
dbg_slider(ref_create(params, "child_length_max"), 1, 2000, "Max child length", 1);
dbg_slider(ref_create(params, "recursion_level_max"), 1, 10, "Max recursion level", 1);
dbg_slider(ref_create(params, "child_cutoff_start"), 0, 1, "Start cutoff", .05);
dbg_slider(ref_create(params, "child_cutoff_end"), 0, 1, "End cutoff", .05);
dbg_checkbox(ref_create(params, "fade_out"), "Fade out");
dbg_slider(ref_create(params, "fade_out_speed"), .001, .15, "Fade out speed", .001);
dbg_checkbox(ref_create(params, "child_reduce_width"), "Reduce child width");
dbg_checkbox(ref_create(params, "child_reduce_alpha"), "Reduce child alpha");
// Fade in & Strike subsection
dbg_text_separator("Fade in & Strike [PRESS RIGHT CLICK TO STRIKE]");
dbg_checkbox(ref_create(params, "fade_in"), "Fade in");
dbg_slider(ref_create(params, "fade_in_speed"), 0.1, 10, "Fade in speed", .1);
dbg_slider(ref_create(params, "duration"), 1, 300, "Strike duration (in frames)", 1);
dbg_slider(ref_create(params, "secondary_noise_strength"), .01, 2, "Secondary noise strength", .01);
dbg_slider(ref_create(params, "secondary_noise_density_multiplier"), 0, 20, "Secondary noise density mult", 1);
dbg_slider(ref_create(params, "end_points_max"), 0, 20, "Max number of random endpoints (only for preview)", 1);

// UNORGANIZED
dbg_text_separator("^. .^");
dbg_checkbox(ref_create(params, "blend_mode_add"), "additive blendmode (high saturation and contrast)");
discokitty = false;
dbg_checkbox(ref_create(self, "discokitty"), "discokitty");

// EXAMPLES - BEAMS
dbg_text_separator("Beam examples");
dbg_button("Precise cut", function() { load_preset(PRESETS.precise_cut) }); dbg_same_line();
dbg_button("Toxic", function() { load_preset(PRESETS.toxic) });
dbg_button("Vampiric touch", function() {  bolt.set_fade_in(false); load_preset(PRESETS.vampiric_touch); }); dbg_same_line();
dbg_button("Abyssal wave", function() {  bolt.set_fade_in(false); load_preset(PRESETS.abyssal_wave); });
dbg_button("Cobweb", function() { load_preset(PRESETS.cobweb) }); dbg_same_line();
dbg_button("Plasma", function() { load_preset(PRESETS.plasma) });
dbg_button("Impulses", function() { load_preset(PRESETS.impulses) }); dbg_same_line();
dbg_button("Wild discharge", function() { load_preset(PRESETS.wild_discharge) });

// EXAMPLES - STRIKES
dbg_text_separator("Strike examples [PRESS RIGHT CLICK TO STRIKE]");
dbg_button("Rose", function() { load_preset_strike(PRESETS.rose) }); dbg_same_line();
dbg_button("Spectre", function() { load_preset_strike(PRESETS.spectre) });
dbg_button("Snek", function() { load_preset_strike(PRESETS.snek)}); dbg_same_line();
dbg_button("Palpatine", function() { load_preset_strike(PRESETS.palpatine) });
dbg_button("Goldi", function() { load_preset_strike(PRESETS.goldi) }); dbg_same_line();
dbg_button("Drain", function() { load_preset_strike(PRESETS.drain) });

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
		if (string_pos("duration", _name) != 0 || string_pos("end_points_max", _name) != 0) continue;
		
		text += $".set_{_name}({params[$ _name]})\n";
	}
	code_text = text;
}

dbg_view("GENERATED CODE", true, 700, 640, 420, 200);
dbg_section("");
dbg_button("COPY CODE TO CLIPBOARD", function() { clipboard_set_text(code_text); }, 260);
dbg_text(ref_create(self, "code_text"));







