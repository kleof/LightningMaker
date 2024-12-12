randomize();
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

end_point = {x: mouse_x, y: mouse_y};
bolt = new Lightning({x:100, y:300}, end_point, 12, .25, 120, -.1);

range = 10; // if range too small (min_length+2), no children
cutoff = max(1, floor(range * .1));
min_length = 3;

p1 = irandom_range(cutoff, range - cutoff - min_length);
p2 = irandom_range(p1 + min_length, range - cutoff);

