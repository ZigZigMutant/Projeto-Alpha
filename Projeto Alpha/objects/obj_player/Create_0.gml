// --- Vida ---
hp_max = 100;
hp = hp_max;

// --- Controle de dano ---
invulnerable = false;
time_invulnerable = 0;
knockback_x = 0;

// --- Movimento ---
move = 0;
hspd = 0;
vspd = 0;
spd = 3;
grav = 0.75;
jumpspd = -12;

// --- Ataque direcional ---
// Posição da espada nos golpes verticais, em relação ao jogador (origem nos pés).
// Os sprites verticais têm origem no centro da borda de baixo.
sword_up_x = 0;
sword_up_y = -36;
sword_down_x = 0;
sword_down_y = 22;
pogo_speed = -9;   // Impulso para cima ao acertar um inimigo com o golpe para baixo

// --- Estado atual do jogador ---
state = PlayerState.FREE;

// --- Dash ---
dash_speed = 8;           // Pixels por frame durante o dash
dash_duration = 10;       // Duração em frames (8 x 10 = 80 pixels de distância)
dash_cooldown = 30;       // Espera em frames antes de poder usar de novo
dash_timer = 0;           // Contador regressivo do dash em andamento
dash_cooldown_timer = 0;  // Contador regressivo da espera
dash_direction = 1;       // 1 = direita, -1 = esquerda

// --- Movimento e colisão ---
// Lê as teclas, calcula as velocidades e move o jogador
handle_movement = function()
{
    move = -keyboard_check(vk_left) + keyboard_check(vk_right);
    hspd = move * spd;

    // Soma o empurrão ao movimento e faz ele diminuir a cada frame
    hspd += knockback_x;
    knockback_x *= 0.85;
    if (abs(knockback_x) < 0.1) knockback_x = 0;

    apply_collisions();
    apply_jump_and_gravity();
}

// Move o jogador por hspd e vspd, parando nas paredes e no chão
apply_collisions = function()
{
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
}

// Pulo (tecla Espaço) e gravidade
apply_jump_and_gravity = function()
{
    var _on_ground = place_meeting(x, y + 1, obj_chao);
    if (_on_ground)
    {
        if (keyboard_check_pressed(vk_space))
        {
            vspd = jumpspd;
        }
    }
    else
    {
        vspd += grav;
    }
}

// --- Ataques ---
// Entra no estado de ataque e toca a animação recebida
start_attack = function(_sprite)
{
    state = PlayerState.ATTACKING;
    sprite_index = _sprite;
    image_index = 0;
    image_speed = 1;
}

// Descobre a direção do golpe pelas setas pressionadas
get_attack_direction = function()
{
    var _up_held = keyboard_check(vk_up);
    var _down_held = keyboard_check(vk_down);
    var _on_ground = place_meeting(x, y + 1, obj_chao);

    if (_up_held) return AttackDirection.UP;

    // Golpe para baixo só existe no ar
    if (_down_held && !_on_ground) return AttackDirection.DOWN;

    return AttackDirection.FORWARD;
}

start_melee_attack = function()
{
    start_attack(spr_attack_player); // Provisório: ainda não existe animação para cima/baixo

    var _direction = get_attack_direction();

    // Cria a hitbox da espada e a vincula ao jogador
    var _sword = instance_create_layer(x, y, layer, obj_sword);
    _sword.owner = id;
    _sword.attack_dir = _direction;

    switch (_direction)
    {
        case AttackDirection.FORWARD:
            _sword.offset_x = 1 * image_xscale;
            _sword.image_xscale = image_xscale;
            break;

        case AttackDirection.UP:
            _sword.sprite_index = spr_sword_up;
            _sword.offset_x = sword_up_x;
            _sword.offset_y = sword_up_y;
            break;

        case AttackDirection.DOWN:
            _sword.sprite_index = spr_sword_down;
            _sword.offset_x = sword_down_x;
            _sword.offset_y = sword_down_y;
            break;
    }
}

// Chamada pela espada quando ela acerta um inimigo
on_sword_hit = function(_attack_dir)
{
    // Pogo: o golpe para baixo faz o jogador quicar
    if (_attack_dir == AttackDirection.DOWN)
    {
        vspd = pogo_speed;
    }
}

start_shoot_attack = function()
{
    start_attack(spr_shoot_player);

    // Define a posição onde a bala sai
    var _bullet = instance_create_layer(x + 24 * image_xscale, y, layer, obj_projetil);
    _bullet.way = image_xscale;
}

// Lê as teclas de ataque (X = espada, C = tiro)
handle_attack_input = function()
{
    var _melee_pressed = keyboard_check_pressed(ord("X"));
    var _shoot_pressed = keyboard_check_pressed(ord("C"));

    if (_melee_pressed)
    {
        start_melee_attack();
    }
    else if (_shoot_pressed)
    {
        start_shoot_attack();
    }
}

// Quando a animação de ataque termina, volta ao estado livre
update_attack_state = function()
{
    var _animation_finished = image_index >= image_number - 1;
    if (_animation_finished)
    {
        state = PlayerState.FREE;
    }
}

// --- Animação ---
update_free_animation = function()
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

// --- Dash ---
// Se apertou Z e a espera acabou, começa o dash
handle_dash_input = function()
{
    var _dash_pressed = keyboard_check_pressed(ord("Z"));
    if (_dash_pressed && dash_cooldown_timer <= 0)
    {
        start_dash();
    }
}

start_dash = function()
{
    state = PlayerState.DASH;
    dash_timer = dash_duration;
    dash_direction = sign(image_xscale); // Dash para o lado em que o jogador olha
    knockback_x = 0;
    sprite_index = spr_run_player;       // Provisório, até existir um sprite de dash
    image_speed = 1;
}

// Roda a cada frame enquanto o dash está ativo
update_dash_state = function()
{
    hspd = dash_direction * dash_speed;
    vspd = 0; // Sem gravidade durante o dash
    apply_collisions();

    dash_timer -= 1;

    // apply_collisions zera o hspd quando o jogador bate numa parede
    var _hit_wall = hspd == 0;
    if (dash_timer <= 0 || _hit_wall)
    {
        end_dash();
    }
}

end_dash = function()
{
    state = PlayerState.FREE;
    dash_cooldown_timer = dash_cooldown;
}

// Faz a espera entre dashes diminuir a cada frame
update_dash_cooldown = function()
{
    if (dash_cooldown_timer > 0)
    {
        dash_cooldown_timer -= 1;
    }
}

// --- Dano ---
// Dano por contato com inimigo
handle_contact_damage = function()
{
    var _enemy = instance_place(x, y, obj_enemy_parent);

    // Só causa dano se existir um inimigo e ele não estiver morto
    if (_enemy != noone && _enemy.state != "dead")
    {
        take_damage(_enemy.damage, _enemy.x);
    }
}

// Função para deixar invencível independente do dano que tomar
take_damage = function(_amount, _source_x)
{
    // Se já está invulnerável, ignora o dano e encerra a função
    if (invulnerable) return;

    hp -= _amount;
    invulnerable = true;
    time_invulnerable = room_speed * 1;

    // Direção do empurrão: para longe de quem causou o dano
    var _direction = sign(x - _source_x);
    if (_direction == 0) _direction = -image_xscale; // Se estiverem no mesmo X, empurra para trás do jogador

    knockback_x = _direction * 6;
    vspd = -2;
}

// Controla o tempo de invulnerabilidade
update_invulnerability = function()
{
    if (invulnerable)
    {
        time_invulnerable -= 1;
        if (time_invulnerable <= 0)
        {
            invulnerable = false;
        }
    }
}

// Checagem de morte
check_death = function()
{
    if (hp <= 0)
    {
        room_restart();
    }
}

// Cria a interface (HUD) caso ainda não exista na sala
if (!instance_exists(obj_hud)) instance_create_depth(0, 0, -100, obj_hud);