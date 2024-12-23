//randomize(); //get/set seed to freeze setup, randomize afterwards
#macro trace show_debug_message
// add particles on end points
// Randomize segments length
// forks?
// arch-like bend? +height(or additional param)*arc_curve?
// separate smoothing type for children? potentially rapid looks better than gentle
// Option to draw every 2nd/3rd frame

outline_width_uniform = shader_get_uniform(shd_outline_mimpy, "width");
tex_uniform = shader_get_uniform(shd_outline_mimpy, "texel_dimensions");

// ***** DEFAULTS ***** //

start_handle = instance_create_layer(520, 264, "Thingies", obj_handle);
end_handle = instance_create_layer(1160, 174, "Thingies", obj_handle);
start_point = new LPoint(start_handle.x, start_handle.y);
end_point = new LPoint(end_handle.x, end_handle.y);

fx_glow_enabled = false;

segment = 12;
density = .25; // preset 2: .25  // tween density -> something like? TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");
height = 120;
spd = -.1; // preset 2: -.29 + smoothing 1 for secondary wave
width = 7;
turbulence = 0;
outline_strength = 4;

glow_outer_intensity = 1.9;
glow_inner_intensity = 13.7;
glow_inner_multiplier = 21;
glow_color = #D6007C;

bolt = new Lightning(start_point, end_point, segment, density, height, spd, width, #D6007C);
bolt2 = new Lightning({x:0, y:0}, {x:600, y:600}, segment, density, height, spd, width, #D6007C);
bolt3 = new Lightning({x:0, y:0}, {x:600, y:600}, segment, density, height, spd, width, #D6007C);

//bolts = [];
//repeat (50) {
//	var bolt = new Lightning(start_point, end_point, segment, density, height, spd, width);
//	array_push(bolts, bolt);
//}


// ***** DEBUG PANEL ***** //

dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 400, 500); // what's up with sliders input btw? >.>
dbg_section("Main Properties");
dbg_slider(ref_create(self, "segment"), 1, 80, "Segment", 1);
dbg_slider(ref_create(self, "density"), 0, 1, "Density", .01);
dbg_slider(ref_create(self, "spd"), -.7, 0, "Speed", .01);
dbg_slider(ref_create(self, "width"), 1, 18, "Width", 1);
dbg_slider(ref_create(self, "height"), 10, 300, "Height", 1);
dbg_slider(ref_create(self, "turbulence"), 0, 20, "Turbulence", 1);

dbg_text_separator("Outline");

//dbg_slider(ref_create(self, "outline_strength"), 0, 20, "Outline strength", 1);

dbg_slider(ref_create(self, "glow_outer_intensity"), 0, 5, "Glow outer intensity", .1);
dbg_slider(ref_create(self, "glow_inner_intensity"), 0, 40, "Glow inner intensity", .1);
dbg_slider(ref_create(self, "glow_inner_multiplier"), 0, 40, "Glow inner multiplier", .1);
dbg_colour(ref_create(self, "glow_color"), "Glow color");

dbg_checkbox(ref_create(self, "fx_glow_enabled"), "Disk blur mode");


surf = -1;
