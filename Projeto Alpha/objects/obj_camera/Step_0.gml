if (instance_exists(obj_player))
{
    var player = instance_find(obj_player, 0);

    // Alvo horizontal: sempre acompanha o jogador
    var target_x = player.x - view_w / 2;

    // Alvo vertical:
    // Salas normais: câmera fica centralizada na altura da sala
    // Salas verticais: câmera acompanha o jogador
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

    // Limitar a câmera aos limites da Room
    target_x = clamp(
        target_x,
        0,
        max(0, room_width - view_w)
    );

    target_y = clamp(
        target_y,
        0,
        max(0, room_height - view_h)
    );

    // Posição atual da câmera
    var current_x = camera_get_view_x(cam);
    var current_y = camera_get_view_y(cam);

    // Movimento suave
    var new_x = lerp(current_x, target_x, camera_speed);
    var new_y = lerp(current_y, target_y, camera_speed);

    // Garantir que a câmera nunca ultrapasse os limites
    new_x = clamp(new_x, 0, max(0, room_width - view_w));
    new_y = clamp(new_y, 0, max(0, room_height - view_h));

    camera_set_view_pos(cam, new_x, new_y);
}