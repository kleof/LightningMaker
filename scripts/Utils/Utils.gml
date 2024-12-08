function remap(_value, _value_min, _value_max, _target_min, _target_max) {
    return (((_value - _value_min) / (_value_max - _value_min)) * (_target_max - _target_min)) + _target_min;
}