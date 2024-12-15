//randomize();
//add particles on end points
// Randomize segments length
// forks?
// arch-like bend? +height(or additional param)*arc_curve?

start_handle = instance_create_layer(520, 264, "Instances", obj_handle);
end_handle = instance_create_layer(1160, 174, "Instances", obj_handle);
start_point = new Point(start_handle.x, start_handle.y);
end_point = new Point(end_handle.x, end_handle.y);

density = .25; // preset 2: .25  // tween density -> something like? TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");
spd = -.1; // preset 2: -.29 + smoothing 1 for secondary wave


bolt = new Lightning(start_point, end_point, 12, .25, 120, -.1, 4);


//clipboard_set_text("HEWWO WOLD");
//surf = -1;



dbg_view("CTRL+click on a slider to enter value directly", true, 10, 30, 400, 500);
dbg_section("Instance variables");
dbg_slider(ref_create(self, "density"), 0, 1, "density", .01);



