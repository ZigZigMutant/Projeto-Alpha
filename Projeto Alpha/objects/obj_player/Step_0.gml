// --- MOVIMENTO E COLISÃO ---
move = -keyboard_check(vk_left) + keyboard_check(vk_right);

hspd = move * spd;

// Soma o empurrão ao movimento e faz ele diminuir a cada frame
hspd += knockback_x;
knockback_x *= 0.85;
if (abs(knockback_x) < 0.1) knockback_x = 0;


// Colisão horizontal
if (place_meeting(x + hspd, y, obj_chao))
{
    while (!place_meeting(x + sign(hspd), y, obj_chao))
    {
        x += sign(hspd);
    }
    hspd = 0;
}

x += hspd;

// Colisão vertical
if (place_meeting(x, y + vspd, obj_chao))
{
    while (!place_meeting(x, y + sign(vspd), obj_chao))
    {
        y += sign(vspd);
    }
    vspd = 0;
}

y += vspd;

// Pulo e gravidade
if (place_meeting(x, y + 1, obj_chao))
{
    if (keyboard_check_pressed(vk_up))
    {
        vspd = jumpspd;
    }
}
else
{
    vspd += grav;
}

// --- ATAQUE E TIRO ---
attack_melee = keyboard_check_pressed(ord("X")); // Tecla X para espada
attack_shoot = keyboard_check_pressed(ord("C")); // Tecla C para tiro

// Ataque corpo a corpo
if (attack_melee && !attacking)
{
    attacking = true;
    sprite_index = spr_attack_player;
    image_index = 0;
    image_speed = 1;

    // Cria a hitbox da espada e a vincula ao jogador
    var _sword = instance_create_layer(x, y, layer, obj_sword);
    _sword.owner = id;
    _sword.offset_x = 1 * image_xscale;
    _sword.image_xscale = image_xscale;
}

// Ataque de tiro
if (attack_shoot && !attacking)
{
    attacking = true;
    sprite_index = spr_shoot_player;
    image_index = 0;
    image_speed = 1;

    // Define a posição onde a bala sai
    var _offset_x = 24 * image_xscale;
    var _bullet = instance_create_layer(x + _offset_x, y, layer, obj_projetil);

	_bullet.way = image_xscale;
}

// Comportamento ENQUANTO estiver atacando
if (attacking)
{
    if (image_index >= image_number - 1)
    {
        attacking = false;
    }
}
// Comportamento normal
else
{
    if (move != 0)
    {
        sprite_index = spr_run_player;
        image_xscale = move;
    }
    else
    {
        sprite_index = spr_player;
    }
}

// --- DANO POR CONTATO COM INIMIGO ---
// Procura um inimigo encostando no jogador
var _enemy = instance_place(x, y, obj_enemy_parent);

// Só causa dano se existir um inimigo e ele não estiver morto
if (_enemy != noone && _enemy.state != "dead")
{
    take_damage(_enemy.damage, _enemy.x);
}

// --- INVULNERABILIDADE E MORTE ---
update_invulnerability();
check_death();


// --- ATALHO DE DEBUG: reinicia a sala ---
if (keyboard_check_pressed(ord("R")))
{
    room_restart();
}