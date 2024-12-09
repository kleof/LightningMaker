randomize();
gradient = animcurve_get_channel(ac_gradient, 1);
variance = animcurve_get_channel(ac_gradient, "variance");

start_p = new Point(100, 300);
end_p = new Point(800, 300);

smooth = .08; // Not 0
dist = point_distance(start_p.x, start_p.y, end_p.x, end_p.y);
len = dist * smooth;
segment = round(1 / smooth);
density = .25;
height = 120;

spd = -.1;
spd_base = spd;

offset = 0;