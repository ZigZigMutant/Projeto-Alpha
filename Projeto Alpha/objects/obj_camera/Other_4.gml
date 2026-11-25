 if (instance_exists(obj_player))
{
    var player = instance_find(obj_player, 0);

    var target_x = clamp(
        player.x - view_w / 2,
        0,
        max(0, room_width - view_w)
    );

    var target_y;

      if (global.camera_vertical)
{
    var player_screen_y = player.y - camera_get_view_y(cam);

    target_y = camera_get_view_y(cam);

    if (player_screen_y > dead_zone_bottom)
    {
        target_y += player_screen_y - dead_zone_bottom;
    }
    else if (player_screen_y < dead_zone_top)
    {
        target_y -= dead_zone_top - player_screen_y;
    }
}
else
{
    target_y = camera_fixed_y;
}

    target_y = clamp(
        target_y,
        0,
        max(0, room_height - view_h)
    );

    // Posicionamento instantâneo
    camera_set_view_pos(cam, target_x, target_y);
}