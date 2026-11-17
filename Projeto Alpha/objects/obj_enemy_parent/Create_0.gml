// Todo inimigo herda daqui. No Create do filho, chame event_inherited()

// --- Vida e estado ---
hp_max = 1;
hp = hp_max;
state = EnemyState.PATROL;

// --- Movimento ---
spd = 1;
hspd = 0;
vspd = 0;
grav = 0.3;
patrol_direction = 1;      // 1 = direita, -1 = esquerda
chase_anim_speed = 1.3;    // Animação um pouco mais rápida ao perseguir

// --- Percepção e ataque ---
sight_radius = 220;        // Distância para notar o jogador
attack_radius = 1;         // Distância para iniciar o ataque
attack_cooldown_duration = 50;
attack_cooldown = 0;

// --- Dano ---
damage = 0;                // Dano por contato no jogador
hurt_duration = 10;        // Frames de stun ao levar um golpe
hurt_timer = 0;
knockback_x = 0;
knockback_force = 3;
knockback_friction = 0.85;

// --- Sprites (cada filho define os seus) ---
sprite_walk = sprite_index;
sprite_attack = sprite_index;
sprite_hurt = sprite_index;
sprite_death = sprite_index;



// CONSULTAS
// O player chama isto no dano por contato.
// Para inimigo atordoado NÃO machucar, use: return state != EnemyState.DEAD && state != EnemyState.HURT;
can_damage_player = function()
{
    return state != EnemyState.DEAD;
}

animation_finished = function()
{
    return image_index >= image_number - 1;
}

set_animation = function(_sprite, _speed)
{
    sprite_index = _sprite;
    image_speed = _speed;
}

// RECEBER GOLPE
// Devolve true se o golpe foi aplicado e false se foi ignorado.
// _source_x é opcional: sem ele, não há empurrão
take_hit = function(_amount, _source_x = undefined)
{
    // Inimigo já morrendo não recebe mais golpes
    if (state == EnemyState.DEAD) return false;

    hp -= _amount;
    image_index = 0;

    knockback_x = 0;
    if (!is_undefined(_source_x))
    {
        var _direction = sign(x - _source_x);
        if (_direction == 0) _direction = -image_xscale;
        knockback_x = _direction * knockback_force;
    }

    if (hp <= 0)
    {
        state = EnemyState.DEAD;
    }
    else
    {
        state = EnemyState.HURT;
        hurt_timer = hurt_duration;
    }

    return true;
}


// MOVIMENTO E COLISÃO
// Move por hspd parando nas paredes. Devolve true se bateu.
move_horizontal = function()
{
    var _hit_wall = false;

    if (place_meeting(x + hspd, y, COLLISION_OBJECT))
    {
        while (!place_meeting(x + sign(hspd), y, COLLISION_OBJECT))
        {
            x += sign(hspd);
        }
        hspd = 0;
        _hit_wall = true;
    }
    x += hspd;

    return _hit_wall;
}

// Gravidade + colisão vertical
move_vertical = function()
{
    vspd += grav;

    if (place_meeting(x, y + vspd, COLLISION_OBJECT))
    {
        while (!place_meeting(x, y + sign(vspd), COLLISION_OBJECT))
        {
            y += sign(vspd);
        }
        vspd = 0;
    }
    y += vspd;
}

// Empurrão que vai diminuindo (usado em hurt e dead)
update_knockback_movement = function()
{
    hspd = knockback_x;
    knockback_x *= knockback_friction;
    move_horizontal();
}


// COMPORTAMENTO POR ESTADO

update_attack_cooldown = function()
{
    if (attack_cooldown > 0)
    {
        attack_cooldown -= 1;
    }
}

// Decide entre patrulhar, perseguir e atacar.
// Não interrompe ataque, stun nem morte.
update_perception = function()
{
    if (state == EnemyState.HURT || state == EnemyState.DEAD || state == EnemyState.ATTACK) return;

    if (!instance_exists(obj_player))
    {
        state = EnemyState.PATROL;
        return;
    }

    var _dist = distance_to_object(obj_player);

    if (_dist <= attack_radius && attack_cooldown <= 0)
    {
        start_attack();
    }
    else if (_dist <= sight_radius)
    {
        state = EnemyState.CHASE;
    }
    else
    {
        state = EnemyState.PATROL;
    }
}

update_patrol = function()
{
    set_animation(sprite_walk, 1);

    hspd = patrol_direction * spd;

    // Bateu na parede: vira para o outro lado
    if (move_horizontal())
    {
        patrol_direction *= -1;
    }

    image_xscale = patrol_direction;
}

update_chase = function()
{
    set_animation(sprite_walk, chase_anim_speed);

    var _direction = sign(obj_player.x - x);
    hspd = _direction * spd;
    if (_direction != 0) image_xscale = _direction;

    move_horizontal();
}

start_attack = function()
{
    state = EnemyState.ATTACK;
    attack_cooldown = attack_cooldown_duration;
    image_index = 0;
    set_animation(sprite_attack, 1);
}

// Para de andar até a animação de ataque terminar, depois volta a perseguir
update_attack = function()
{
    hspd = 0;

    if (animation_finished())
    {
        state = EnemyState.CHASE;
    }
}

update_hurt = function()
{
    set_animation(sprite_hurt, 1);
    update_knockback_movement();

    hurt_timer -= 1;
    if (hurt_timer <= 0)
    {
        knockback_x = 0;
        state = EnemyState.CHASE; // update_perception corrige no próximo frame
    }
}

// Some quando o último frame da animação de morte termina
update_dead = function()
{
    set_animation(sprite_death, 1);
    update_knockback_movement();

    if (animation_finished())
    {
        instance_destroy();
    }
}
