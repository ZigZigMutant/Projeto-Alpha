// Porta sem destino configurado não faz nada
if (target_room == noone) exit;

if (place_meeting(x, y, obj_player))
{
    // Cria o controlador na primeira vez que ele for necessário
    if (!instance_exists(obj_transition))
    {
        instance_create_depth(0, 0, -10000, obj_transition);
    }

    obj_transition.begin_transition(target_room, target_x, target_y);
}