//randomize();
smoothing_base = animcurve_get_channel(ac_smoothing, "gentle");
smoothing_secondary = animcurve_get_channel(ac_smoothing, "rapid2");

start_p = {x: 100, y:300};
end_p = {x: 1200, y:300};

segment = 12; // Not 0 // Randomize segments length
dist = point_distance(start_p.x, start_p.y, end_p.x, end_p.y);
len = dist / segment;

density = .25; // preset 2: .25  // tween density
height = 120;

spd = -.1; // preset 2: -.29 + smoothing 1 for secondary wave


//TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");

bolt = new Lightning(100,300, mouse_x,mouse_y, 12, .25, 120, -.1);
