
 // Sem dono, não existe golpe
if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}

// Acompanha o dono
x = owner.x + offset_x;
y = owner.y + offset_y;

// Verifica inimigos em uma área maior que a máscara original
var _enemy = collision_rectangle(
    bbox_left - hitbox_expand,
    bbox_top - hitbox_expand,
    bbox_right + hitbox_expand,
    bbox_bottom + hitbox_expand,
    obj_enemy_parent,
    false,
    true
);

// Se acertou um inimigo
if (_enemy != noone)
{
    if (_enemy.take_hit(damage, x))
    {
        // Avisa o jogador que acertou
        if (instance_exists(owner))
        {
                   owner.on_sword_hit(attack_dir);
        }

        instance_destroy();
        exit;
    }
}

// Quando o tempo acabar, a hitbox se destrói
lifetime -= 1;

if (lifetime <= 0)
{
    instance_destroy();
}
