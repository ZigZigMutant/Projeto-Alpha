switch (state)
{
    case "fade_out":
        alpha += fade_speed;
        if (alpha >= 1)
        {
            alpha = 1;
            state = "changing";

            // Guarda a vida do jogador antes de trocar de sala
            if (instance_exists(obj_player)) saved_hp = obj_player.hp; 

            room_goto(target_room);
        }
        break;

    case "fade_in":
        alpha -= fade_speed;
        if (alpha <= 0)
        {
            alpha = 0;
            state = "idle";
        }
        break;
} 