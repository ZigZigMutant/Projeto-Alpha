// ============================================================
// obj_player | Create
// ============================================================

// --- Entrada (atualizada todo frame no Step) ---
input = input_get();

// --- Renascimento: se acabou de morrer, nasce no último altar ---
if (global.respawning && global.checkpoint != undefined)
{
    x = global.checkpoint.x;
    y = global.checkpoint.y;
    global.respawning = false;
}

// --- Estado atual ---
state = PlayerState.FREE;

// --- Vida ---
hp_max = 100;
hp = hp_max;

// --- Movimento ---
move = 0;
hspd = 0;
vspd = 0;
spd = 3;
grav = 0.65;
jumpspd = -12;

grav_fall = 0.35;   // gravidade na queda (menor = cai mais devagar)
max_fall = 8;       // velocidade máxima de queda

// --- Dano ---
invulnerable = false;
time_invulnerable = 0;
invulnerable_duration = 60;  // Frames de invencibilidade após o dano
knockback_x = 0;
knockback_force = 6;         // Velocidade inicial do empurrão
knockback_friction = 0.85;   // Quanto do empurrão sobra a cada frame
hurt_lift = -2;              // Pequeno salto ao ser atingido
hurt_duration = 15;          // Frames sem controle após o dano
hurt_timer = 0;
has_hit = false;

// --- Morte ---
death_screen_delay = 60;     // Frames entre morrer e a tela de morte começar (dura a queda)
death_timer = 0;

// --- Ataque ---
active_sword = noone;        // Hitbox da espada em andamento
shoot_offset_x = 24;         // Distância da saída da bala em relação ao jogador

// Posição da espada em relação ao jogador (origem nos pés).
// Os sprites verticais têm origem no centro da borda de baixo.
sword_forward_x = 1;
sword_up_x = 0;
sword_up_y = -36;
sword_down_x = 0;
sword_down_y = 22;

// --- Pogo ---
pogo_speed = -9;
pogo_active = false;
pogo_contact_timer = 0;
pogo_contact_duration = 12;

// --- Poção de cura ---
potion_max = 2;              // Cargas máximas
potion_charges = potion_max; // Cargas atuais
potion_heal_amount = 40;     // Vida recuperada por carga
potion_drink_duration = 50;  // Frames bebendo (levar dano cancela e a carga se perde)
potion_timer = 0;

// --- Mana ---
mana_max = 50;
mana = mana_max;
shoot_cost = 10;             // Custo de cada tiro
mana_gain_on_hit = 6;        // Mana ganha a cada golpe de espada que acerta
mana_flash_timer = 0;        // Faz a barra piscar em vermelho quando falta mana (HUD)
mana_gain_timer = 0;         // Faz a barra brilhar ao ganhar mana (HUD)

// --- Meditação no altar ---
meditate_duration = 140;     // Frames: reverência, bênção (no meio) e levantar
meditate_timer = 0;
meditate_restored = false;   // A bênção acontece uma vez só por meditação
meditate_altar = noone;

// --- Dash ---
dash_speed = 8;              // Pixels por frame (8 x 10 = 80 pixels de distância)
dash_duration = 10;          // Frames
dash_cooldown = 30;          // Frames de espera antes de usar de novo
dash_timer = 0;
dash_cooldown_timer = 0;
dash_direction = 1;          // 1 = direita, -1 = esquerda


// ============================================================
// MOVIMENTO E COLISÃO
// ============================================================

is_on_ground = function()
{
    return place_meeting(x, y + 1, COLLISION_OBJECT);
}

// Calcula as velocidades pelo input e move o jogador
handle_movement = function()
{
    move = input.move_x;
    hspd = move * spd;

    handle_jump();
    apply_gravity();
    apply_collisions();
}

handle_jump = function()
{
    if (input.jump_pressed && is_on_ground())
    {
        vspd = jumpspd;
    }

    // Não reduz a velocidade durante o impulso do pogo
    if (vspd < 0 && !input.jump_held && !pogo_active)
    {
        vspd = max(vspd, jumpspd / 3);
    }
}


apply_gravity = function()
{
    if (!is_on_ground())
    {

    }
}

// Move o jogador por hspd e vspd, parando nas paredes e no chão

apply_collisions = function()
{
    // Horizontal
    if (place_meeting(x + hspd, y, COLLISION_OBJECT))
    {
        while (!place_meeting(x + sign(hspd), y, COLLISION_OBJECT))
        {
            x += sign(hspd);
        }

        hspd = 0;
    }

    x += hspd;

    // Vertical
    if (vspd < 0)
    {
        vspd += grav;
    }
    else
    {
        vspd += grav_fall;
    }

    vspd = min(vspd, max_fall);

    if (place_meeting(x, y + vspd, COLLISION_OBJECT))
    {
        while (!place_meeting(x, y + sign(vspd), COLLISION_OBJECT))
        {
            y += sign(vspd);
        }

        vspd = 0;
    }

    y += vspd;

    // Encerra o pogo quando o jogador começa a descer
    if (pogo_active && vspd >= 0)
    {
        pogo_active = false;
    }
}

// ============================================================
// ANIMAÇÃO
// ============================================================

update_free_animation = function()
{
    image_speed = 1; // Garante que a animação volte a rodar após beber (ou ser interrompido)

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


// ============================================================
// ATAQUES
// ============================================================

// Entra no estado de ataque e toca a animação recebida
start_attack = function(_sprite)
{
    state = PlayerState.ATTACKING;
    sprite_index = _sprite;
    image_index = 0;
    image_speed = 1;
}

// Lê W/S para decidir a direção do golpe
get_attack_direction = function()
{
    if (input.up) return AttackDirection.UP;

    // Golpe para baixo só existe no ar
    if (input.down && !is_on_ground()) return AttackDirection.DOWN;

    return AttackDirection.FORWARD;
}

// Cria a hitbox da espada, posicionada conforme a direção

create_sword = function(_direction)
{
    var _sword = instance_create_layer(x, y, layer, obj_sword);
    _sword.owner = id;
    _sword.attack_dir = _direction;

    // Aumenta o tamanho de todas as espadas em 25%
    _sword.image_xscale = 1.25;
    _sword.image_yscale = 1.25;

    switch (_direction)
    {
        case AttackDirection.FORWARD:
            _sword.offset_x = sword_forward_x * image_xscale;
            _sword.image_xscale *= image_xscale;
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
	// A espada do objeto só aparece nos ataques direcionais
_sword.visible = (_direction != AttackDirection.FORWARD);

    return _sword;
}

start_melee_attack = function()
{
    var _direction = get_attack_direction();

    // Ataque horizontal mantém a animação com espada
    if (_direction == AttackDirection.FORWARD)
    {
        start_attack(spr_attack_player);
    }
    else
    {
        // Ataques verticais usam o personagem sem a espada antiga
        start_attack(spr_player);
    }

    active_sword = create_sword(_direction);
}

start_shoot_attack = function()
{
    start_attack(spr_shoot_player);
    spend_mana(shoot_cost);

    var _bullet = instance_create_layer(x + shoot_offset_x * image_xscale, y, layer, obj_projetil);
    _bullet.way = image_xscale;
}

// Remove a espada em andamento (ex.: ao levar dano)
cancel_sword = function()
{
    if (instance_exists(active_sword))
    {
        instance_destroy(active_sword);
    }
    active_sword = noone;
}

// Chamada pela espada quando ela acerta um inimigo
// Chamada pela espada quando ela acerta um inimigo
on_sword_hit = function(_attack_dir)
{
    gain_mana(mana_gain_on_hit);

    // Pogo: impulso vertical ao acertar um inimigo
    if (_attack_dir == AttackDirection.DOWN)
    {
        vspd = pogo_speed;
        pogo_active = true;

        // Evita empurrão horizontal no momento do pogo
        knockback_x = 0;

        // Proteção temporária contra contato
        pogo_contact_timer = pogo_contact_duration;
    }
}

handle_attack_input = function()
{
    if (input.melee_pressed)
    {
        start_melee_attack();
    }
    else if (input.shoot_pressed)
    {
        if (can_afford_mana(shoot_cost))
        {
            start_shoot_attack();
        }
        else
        {
            deny_not_enough_mana();
        }
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


// ============================================================
// DASH
// ============================================================

handle_dash_input = function()
{
    if (input.dash_pressed && dash_cooldown_timer <= 0)
    {
        start_dash();
    }
}

start_dash = function()
{
    state = PlayerState.DASH;
    dash_timer = dash_duration;
    dash_direction = sign(image_xscale); // Dash para o lado em que o jogador olha
    sprite_index = spr_run_player;       // Provisório, até existir um sprite de dash
    image_speed = 1;
}

update_dash_state = function()
{
    hspd = dash_direction * dash_speed;
    vspd = 0; // Sem gravidade durante o dash
    apply_collisions();

    dash_timer -= 1;

    // apply_collisions zera o hspd quando o jogador bate numa parede
    var _hit_wall = (hspd == 0);
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

update_dash_cooldown = function()
{
    if (dash_cooldown_timer > 0)
    {
        dash_cooldown_timer -= 1;
    }
}


// ============================================================
// DANO, MORTE E INVENCIBILIDADE
// ============================================================

// Dano por contato com inimigo
handle_contact_damage = function()
{
    // Proteção temporária após executar um pogo
    if (pogo_contact_timer > 0) return;

    var _enemy = instance_place(x, y, obj_enemy_parent);

    // Só causa dano se existir um inimigo e ele puder ferir o jogador
    if (_enemy != noone && _enemy.can_damage_player())
    {
        take_damage(_enemy.damage, _enemy.x);
    }
}

// Aplica dano, empurrão e invencibilidade temporária
take_damage = function(_amount, _source_x)
{
    if (invulnerable || state == PlayerState.DEAD || state == PlayerState.MEDITATE) return;

    hp = max(hp - _amount, 0);
    invulnerable = true;
    time_invulnerable = invulnerable_duration;
    cancel_sword();

    // Empurrão para longe de quem causou o dano
    var _direction = sign(x - _source_x);
    if (_direction == 0) _direction = -image_xscale; // Mesmo X: empurra para trás do jogador

    knockback_x = _direction * knockback_force;
    vspd = hurt_lift;

    state = PlayerState.HURT;
    hurt_timer = hurt_duration;
}

// Jogador sem controle: só sofre o empurrão e a gravidade
update_hurt_state = function()
{
    hspd = knockback_x;
    knockback_x *= knockback_friction;

    apply_gravity();
    apply_collisions();

    hurt_timer -= 1;
    if (hurt_timer <= 0)
    {
        knockback_x = 0;
        state = PlayerState.FREE;
    }
}

update_invulnerability = function()
{
    if (!invulnerable) return;

    time_invulnerable -= 1;
    if (time_invulnerable <= 0)
    {
        invulnerable = false;
    }
}

check_death = function()
{
    if (hp > 0 || state == PlayerState.DEAD) return;

    state = PlayerState.DEAD;
    death_timer = death_screen_delay;
    cancel_sword();

    sprite_index = spr_death_player;
    image_index = 0;
    image_speed = 0; // A animação acompanha o tempo (ver update_dead_state)
}

// Espera um instante e abre a tela de morte. O jogador só renasce quando
// aperta R nela (a própria tela chama respawn()).
update_dead_state = function()
{
    hspd = 0;
    apply_gravity();
    apply_collisions();

    death_timer -= 1;

    // A queda acompanha o tempo e o último frame fica parado no chão
    var _progress = clamp(1 - death_timer / death_screen_delay, 0, 1);
    image_index = min(_progress * image_number, image_number - 0.01);

    if (death_timer == 0)
    {
        show_death_screen();
    }
}

show_death_screen = function()
{
    var _screen = instance_create_depth(0, 0, -10000, obj_death_screen);
    _screen.owner = id;
}


// ============================================================
// POÇÃO DE CURA
// ============================================================

// Só bebe parado no chão, com carga e sem a vida cheia (evita desperdício)
can_drink_potion = function()
{
    return state == PlayerState.FREE
        && is_on_ground()
        && potion_charges > 0
        && hp < hp_max;
}

handle_potion_input = function()
{
    if (input.heal_pressed && can_drink_potion())
    {
        start_drinking();
    }
}

// A carga é gasta ao começar; a cura só entra se a animação terminar
start_drinking = function()
{
    state = PlayerState.HEAL;
    potion_charges -= 1;
    potion_timer = potion_drink_duration;
    hspd = 0;
    sprite_index = spr_drink_player;
    image_index = 0;
    image_speed = 0; // A animação acompanha o tempo restante (ver update_heal_state)
}

// Parado e vulnerável: se levar dano, take_damage muda o estado e a cura se perde
update_heal_state = function()
{
    hspd = 0;
    apply_gravity();
    apply_collisions();

    potion_timer -= 1;

    // A animação acompanha o tempo restante, qualquer que seja a duração
    var _progress = 1 - potion_timer / potion_drink_duration;
    image_index = min(_progress * image_number, image_number - 0.01);

    if (potion_timer <= 0)
    {
        finish_drinking();
    }
}

// Aplica a cura, devolve o controle e dispara o efeito vermelho
finish_drinking = function()
{
    hp = min(hp + potion_heal_amount, hp_max);
    state = PlayerState.FREE;
    image_speed = 1;

    spawn_heal_effect();
}

// Chamada pelo altar ao meditar
restore_potions = function()
{
    potion_charges = potion_max;
}


// ============================================================
// MANA
// ============================================================

can_afford_mana = function(_cost)
{
    return mana >= _cost;
}

spend_mana = function(_amount)
{
    mana = max(mana - _amount, 0);
}

// Mana ganha em combate (golpes de espada que acertam)
gain_mana = function(_amount)
{
    var _before = mana;
    mana = min(mana + _amount, mana_max);
    if (mana > _before) mana_gain_timer = 12;
}

restore_mana = function()
{
    mana = mana_max;
    mana_gain_timer = 30;
}

// Tentou gastar mana sem ter o bastante: a barra pisca em vermelho
deny_not_enough_mana = function()
{
    mana_flash_timer = 24;
}

// Faz os efeitos visuais da barra de mana durarem pouco tempo
update_mana_feedback = function()
{
    if (mana_flash_timer > 0) mana_flash_timer -= 1;
    if (mana_gain_timer > 0) mana_gain_timer -= 1;
}


// ============================================================
// ALTAR: RESTAURAÇÃO, CHECKPOINT E MEDITAÇÃO
// ============================================================

// Vida, mana e poções de uma vez (usada no altar)
restore_all = function()
{
    hp = hp_max;
    restore_mana();
    restore_potions();
}

// Guarda o altar como ponto de renascimento
set_checkpoint = function(_altar)
{
    global.checkpoint = { room_id: room, x: _altar.respawn_x, y: _altar.respawn_y };
}

// Chamada pela tela de morte: volta ao último altar usado ou, se ainda não
// encontrou nenhum, ao começo da fase.
respawn = function()
{
    if (global.checkpoint != undefined)
    {
        global.respawning = true;
        room_goto(global.checkpoint.room_id);
    }
    else
    {
        room_goto(LEVEL_START_ROOM);
    }
}

spawn_heal_effect = function()
{
    var _effect = instance_create_depth(x, y, depth - 1, obj_heal_effect);
    _effect.owner = id;
}

handle_interact_input = function()
{
    if (!input.interact_pressed || !is_on_ground()) return;

    var _altar = instance_place(x, y, obj_altar);
    if (_altar != noone)
    {
        start_meditating(_altar);
    }
}

start_meditating = function(_altar)
{
    state = PlayerState.MEDITATE;
    meditate_altar = _altar;
    meditate_timer = meditate_duration;
    meditate_restored = false;
    hspd = 0;

    // Vira de frente para o altar
    var _direction = sign(_altar.x - x);
    if (_direction != 0) image_xscale = _direction;

    sprite_index = spr_meditate_player;
    image_index = 0;
    image_speed = 0; // A animação acompanha o tempo (ver update_meditate_state)
}

// Imóvel e imune a dano. No auge da reverência (metade do tempo), o altar abençoa.
update_meditate_state = function()
{
    hspd = 0;
    apply_gravity();
    apply_collisions();

    meditate_timer -= 1;
    var _progress = 1 - meditate_timer / meditate_duration;
    image_index = min(_progress * image_number, image_number - 0.01);

    if (!meditate_restored && _progress >= 0.5)
    {
        meditate_restored = true;
        bless_at_altar();
    }

    if (meditate_timer <= 0)
    {
        state = PlayerState.FREE;
        image_speed = 1;
    }
}

bless_at_altar = function()
{
    restore_all();
    set_checkpoint(meditate_altar);
    meditate_altar.activate();
    spawn_heal_effect();
}


// --- Interface (HUD) ---
if (!instance_exists(obj_hud)) instance_create_depth(0, 0, -100, obj_hud);
