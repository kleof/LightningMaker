#macro trace show_debug_message
//randomize(); //get/set seed to freeze setup, randomize afterwards
// add particles on end points (and slower, from line beam)
// Randomize segments length
// forks?
// arch-like bend? +height(or additional param)*arc_curve?
// separate smoothing type for children? potentially rapid looks better than gentle
// tween density -> something like? TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");
// Option to draw every 2nd/3rd frame
// allow children's endpoint anywhere, on parents and other children, or maybe just on main branch?

// ***** DEFAULTS ***** //

start_handle = instance_create_layer(520, 264, "Thingies", obj_handle, {image_alpha: .3});
end_handle = instance_create_layer(1160, 174, "Thingies", obj_handle, {image_alpha: .3});
start_point = new LPoint(start_handle.x, start_handle.y);
end_point = new LPoint(end_handle.x, end_handle.y);

load_all_defaults = function() {
	segment = 12;
	density = .25;
	height = 120;
	spd = -.1;
	turbulence = 0;
	width = 4;
	outline_width = 5;
	color = #FFFFFF;
	outline_color = #E90057;
	smoothing_type = SMOOTHING_GENTLE;

	neon_glow_intensity = 1.9;
	neon_glow_inner = 13.7;
	neon_glow_inner_mult = 21;

	disk_glow_radius = 256;
	disk_glow_quality = 5.5;
	disk_glow_intensity = 1;
	disk_glow_alpha = 1;
	disk_glow_gamma = .2;
	
	child_chance = .10;
	child_life_min = 6; 
	child_life_max = 60;
	children_max = 3;
	
	if (struct_exists(self, "bolt")) bolt.set_glow_type(GLOW_TYPE_DISK);
}
load_all_defaults();

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

activate_disk_mode = function() {
	bolt.set_glow_type(GLOW_TYPE_DISK);
}
activate_neon_mode = function() {
	bolt.set_glow_type(GLOW_TYPE_NEON);
}
activate_none_mode = function() {
	bolt.set_glow_type(GLOW_TYPE_NONE);
}

load_disk_mode_defaults = function() {
	bolt.set_glow_type(GLOW_TYPE_DISK);
	width = 4;
	color = #FFFFFF;
	outline_color = #E90057;
	outline_width = 5;
}
load_neon_mode_defaults = function() {
	bolt.set_glow_type(GLOW_TYPE_NEON);
	width = 6;
	color = 6226135;
	outline_width = 0;
}



// ***** DEBUG PANEL ***** //

dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 450, 750); // what's up with sliders input btw? >.>
dbg_section("Main Properties");
dbg_button("RESET ALL", load_all_defaults, 230); dbg_same_line();
dbg_button("Turn OFF Glow", activate_none_mode);

dbg_slider(ref_create(self, "segment"), 1, 80, "Segment", 1);
dbg_slider(ref_create(self, "density"), 0, 1, "Density", .01);
dbg_slider(ref_create(self, "spd"), -.7, 0, "Speed", .01);
dbg_slider(ref_create(self, "height"), 10, 300, "Height", 1);
dbg_slider(ref_create(self, "turbulence"), 0, 20, "Turbulence", 1);
dbg_drop_down(ref_create(self, "smoothing_type"), "Rapid:0,Gentle:1,Sine:2,Rapid2:3,OpenEnd:4", "Endpoints smoothing");

// LINES
dbg_text_separator("Line");
dbg_slider(ref_create(self, "width"), 1, 18, "Line width", 1);
dbg_colour(ref_create(self, "color"), "Main color");
dbg_slider(ref_create(self, "outline_width"), 0, 20, "Outline width", 1);
dbg_colour(ref_create(self, "outline_color"), "Outline color");

// NEON GLOW
dbg_text_separator("Neon Glow Settings");
dbg_button("Load \"Neon Glow\" line defaults", load_neon_mode_defaults, 230); dbg_same_line();
dbg_button("Turn it ON only", activate_neon_mode);
dbg_slider(ref_create(self, "neon_glow_intensity"), 0, 5, "Outer intensity", .1);
dbg_slider(ref_create(self, "neon_glow_inner"), 0, 40, "Inner intensity", .1);
dbg_slider(ref_create(self, "neon_glow_inner_mult"), 0, 40, "Inner multiplier", .1);

// DISK GLOW
dbg_text_separator("Disk Glow Settings");
dbg_button("Load \"Disk Glow\" line defaults", load_disk_mode_defaults, 230); dbg_same_line();
dbg_button("Turn it ON only", activate_disk_mode);
dbg_slider(ref_create(self, "disk_glow_intensity"), 0, 1, "Intensity", .1);
dbg_slider(ref_create(self, "disk_glow_gamma"), 0, 2, "Gamma", .1);
dbg_slider(ref_create(self, "disk_glow_alpha"), 0, 1, "Alpha", .1);
dbg_slider(ref_create(self, "disk_glow_radius"), 1, 1024, "Radius", 1);
dbg_slider(ref_create(self, "disk_glow_quality"), 3, 10, "Quality", .5);

// CHILDREN
dbg_text_separator("Children Settings");
dbg_slider(ref_create(self, "child_chance"), 0, 1, "Child chance", .05);
dbg_slider(ref_create(self, "children_max"), 0, 10, "Max children amount", 1); // maybe allow for more
dbg_slider(ref_create(self, "child_life_min"), 0, 300, "Min child life", 1);
dbg_slider(ref_create(self, "child_life_max"), 0, 300, "Max child life", 1);


//outline_width_uniform = shader_get_uniform(shd_outline_mimpy, "width");
//tex_uniform = shader_get_uniform(shd_outline_mimpy, "texel_dimensions");
//surf = -1;



