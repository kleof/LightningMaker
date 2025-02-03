if (dragging) {
    x = mouse_x - xoffset;
    y = mouse_y - yoffset;
	
    if (mouse_check_button_released(mb_left)) {
        dragging = false;    
    }
}
else if (mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id)) {
    dragging = true;
    xoffset = mouse_x - x;
    yoffset = mouse_y - y;
}
