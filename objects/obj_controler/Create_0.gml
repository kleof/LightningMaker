//randomize();
//add particles on end points
// Randomize segments length
// forks?
// arch-like bend? +height(or additional param)*arc_curve?
// separate smoothing type for children? potentially rapid looks better than gentle
// Option to draw every 2nd/3rd frame

start_handle = instance_create_layer(520, 264, "Thingies", obj_handle);
end_handle = instance_create_layer(1160, 174, "Thingies", obj_handle);
start_point = new Point(start_handle.x, start_handle.y);
end_point = new Point(end_handle.x, end_handle.y);

fx_glow_enabled = true;
fx_outline_width = 1;
fx_outline_color = 7868927;
fx_outline = layer_get_fx("Lightnings");


segment = 12;
density = .25; // preset 2: .25  // tween density -> something like? TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");
height = 120;
spd = -.1; // preset 2: -.29 + smoothing 1 for secondary wave
width = 4;


bolt = new Lightning(start_point, end_point, segment, density, height, spd, width);


//clipboard_set_text("HEWWO WOLD");


dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 400, 500);
dbg_section("Main Properties");
dbg_slider(ref_create(self, "segment"), 1, 80, "Segment", 1);
dbg_slider(ref_create(self, "density"), 0, 1, "Density", .01); // what's up with slider input? >.>
dbg_slider(ref_create(self, "spd"), -.7, 0, "Speed", .01);
dbg_slider(ref_create(self, "width"), 1, 18, "Width", 1);
dbg_slider(ref_create(self, "height"), 10, 300, "Height", 1);

dbg_text_separator("Effects");

dbg_checkbox(ref_create(self, "fx_glow_enabled"), "Glow");
dbg_slider(ref_create(self, "fx_outline_width"), 0, 5, "Outline strength", 1);
dbg_drop_down(ref_create(self, "fx_outline_color"), "Rose:7868927,Steel:16741378,Toxic:2686792,Gold:1163263,Cyan:11992832", "Outline color");


