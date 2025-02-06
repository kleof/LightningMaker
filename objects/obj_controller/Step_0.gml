if (discokitty) params.color = make_color_hsv((current_time*0.2 % 255), 255, 255);
params.child_life_min = min(params.child_life_min, params.child_life_max);
params.child_length_min = min(params.child_length_min, params.child_length_max);

generate_code();

set_all_bolt_params();

// crash button
//if (mouse_check_button_pressed(mb_left)) instance_destroy(start_handle);


if (mouse_check_button_pressed(mb_right)) {
	strike_random();
}
