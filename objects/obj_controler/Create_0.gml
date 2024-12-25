#macro trace show_debug_message
//randomize(); //get/set seed to freeze setup, randomize afterwards
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


segment = 12;
density = .25; // preset 2: .25  // tween density -> something like? TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");
height = 120;
spd = -.1; // preset 2: -.29 + smoothing 1 for secondary wave
turbulence = 0;
width = 4;
outline_width = 6;
color = #FFFFFF;
outline_color = #D6007C;

neon_glow_intensity = 1.9;
neon_glow_inner = 13.7;
neon_glow_inner_mult = 21;

disk_glow_radius = 256;
disk_glow_quality = 5;
disk_glow_intensity = 1;
disk_glow_alpha = 1; //!
disk_glow_gamma = 0;

bolt = new Lightning(start_point, end_point, segment, density, height, spd, width, #D6007C);
bolt2 = new Lightning({x:0, y:0}, {x:600, y:600}, segment, density, height, spd, width, #D6007C);
bolt3 = new Lightning({x:0, y:0}, {x:600, y:600}, segment, density, height, spd, width, #D6007C);
bolt4 = new Lightning({x:0, y:0}, {x:600, y:600}, segment, density, height, spd, width, #D6007C);
bolt5 = new Lightning({x:0, y:0}, {x:600, y:600}, segment, density, height, spd, width, #D6007C);

//bolts = [];
//repeat (50) {
//	var bolt = new Lightning(start_point, end_point, segment, density, height, spd, width);
//	array_push(bolts, bolt);
//}


// ***** DEBUG PANEL ***** //

dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 450, 650); // what's up with sliders input btw? >.>
dbg_section("Main Properties");
dbg_slider(ref_create(self, "segment"), 1, 80, "Segment", 1);
dbg_slider(ref_create(self, "density"), 0, 1, "Density", .01);
dbg_slider(ref_create(self, "spd"), -.7, 0, "Speed", .01);
dbg_slider(ref_create(self, "height"), 10, 300, "Height", 1);
dbg_slider(ref_create(self, "turbulence"), 0, 20, "Turbulence", 1);

dbg_text_separator("Secondary");
dbg_slider(ref_create(self, "width"), 1, 18, "Line width", 1);
dbg_colour(ref_create(self, "color"), "Main color");
dbg_slider(ref_create(self, "outline_width"), 0, 20, "Outline width", 1);
dbg_colour(ref_create(self, "outline_color"), "Outline color");

dbg_text_separator("Neon Glow Settings");

dbg_slider(ref_create(self, "neon_glow_intensity"), 0, 5, "Outer intensity", .1);
dbg_slider(ref_create(self, "neon_glow_inner"), 0, 40, "Inner intensity", .1);
dbg_slider(ref_create(self, "neon_glow_inner_mult"), 0, 40, "Inner multiplier", .1);

dbg_text_separator("Disk Glow Settings");

//add "Disk glow preset" button
dbg_checkbox(ref_create(self, "fx_glow_enabled"), "Disk blur mode");

dbg_slider(ref_create(self, "disk_glow_intensity"), 0, 1, "Intensity", .1);
dbg_slider(ref_create(self, "disk_glow_gamma"), 0, 2, "Gamma", .1);
dbg_slider(ref_create(self, "disk_glow_alpha"), 0, 1, "Alpha", .1);
dbg_slider(ref_create(self, "disk_glow_radius"), 1, 1024, "Radius", 1);
dbg_slider(ref_create(self, "disk_glow_quality"), 3, 10, "Quality", .5);







surf = -1;
