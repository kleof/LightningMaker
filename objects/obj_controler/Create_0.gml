randomize();
smoothing_base = animcurve_get_channel(ac_smoothing, "gentle");
smoothing_secondary = animcurve_get_channel(ac_smoothing, "rapid2");

start_p = new Point(100, 300);
end_p = new Point(800, 300);

smooth = .08; // Not 0
dist = point_distance(start_p.x, start_p.y, end_p.x, end_p.y);
len = dist * smooth;
segment = round(1 / smooth);
density = .25; // preset 2: .25
height = 120;

spd = -.1; // preset 2: -.29 + smoothing 1 for secondary wave
spd_base = spd;

offset = 0;

//TweenFire(id, "ioQuad", 2, true, 0, 4, "density>", "@-.1");
