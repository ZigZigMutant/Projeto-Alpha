if (!instance_exists(obj_player)) exit;

var _target_x = obj_player.x - cam_w / 2;
var _target_y = obj_player.y + offset_y - cam_h / 2;

if (!snapped)
{
    cam_x = _target_x;
    cam_y = _target_y;
    snapped = true;
}
else
{
    cam_x = lerp(cam_x, _target_x, follow_speed);
    cam_y = lerp(cam_y, _target_y, follow_speed);
}

// Não mostra nada fora da sala
// Não mostra nada fora dos limites
cam_x = clamp(cam_x, bound_left, max(bound_left, bound_right - cam_w));
cam_y = clamp(cam_y, bound_top, max(bound_top, bound_bottom - cam_h));

// Arredonda só na hora de aplicar, para o pixel art não tremer
camera_set_view_pos(cam, round(cam_x), round(cam_y));

}