// Movimento horizontal
x += direction_x * move_speed;

// Verifica colisão com o jogador
var _player = collision_circle(
    x, y, radius, obj_player, false, true
);

if (_player != noone)
{
    _player.take_damage(damage, x);
    instance_destroy();
    exit;
}

// Destrói ao atingir uma parede
if (place_meeting(x, y, COLLISION_OBJECT))
{
    instance_destroy();
    exit;
}

// Tempo de vida
life_timer -= 1;

if (life_timer <= 0)
{
    instance_destroy();
}