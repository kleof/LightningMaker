start_point.set_position(start_handle.x, start_handle.y);
end_point.set_position(end_handle.x, end_handle.y);


bolt.density = density;
bolt.spd = spd;
bolt.width = width;

bolt.base_segment = segment;
bolt._update_params();
