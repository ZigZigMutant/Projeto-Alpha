// Herda as variáveis e funções comuns dos inimigos
event_inherited();

// --- Identidade ---
boss_name = "Necromante";

// --- Vida ---
hp_max = 400;
hp = hp_max;
hp_trail = hp;
hp_trail_delay = 0;

// --- Combate ---
damage = 25;

// --- Estado ---
state = BossState.IDLE;

// --- Ataque especial de invocação ---
special_attack_triggered = false;
special_attack_started = false;

special_target_y = 100;
special_ground_y = y;
special_fly_speed = 3;

summoned_enemy_1 = noone;
summoned_enemy_2 = noone;
summoned_enemy_3 = noone;

// --- Teletransporte ---
teleport_timer = 150;
teleport_duration = 25;
appear_duration = 20;
phase_timer = 0;

// --- Ataque de projéteis ---
attack_timer = 30;
attack_phase = 0;
projectile_delay = 35;
projectile_timer = 0;

// --- Efeitos ---
flash_timer = 0;
death_timer = 0;
death_duration = 90;

// --- Barra de vida ---
bar_width = 260;
bar_height = 8;
bar_margin_bottom = 22;


// O chefe só causa dano por contato enquanto estiver vivo
can_damage_player = function()
{
    return state == BossState.IDLE;
}

// O chefe não recebe stun nem empurrão
take_hit = function(_amount, _source_x = undefined)
{
    if (state != BossState.IDLE) return false;

    hp = max(hp - _amount, 0);
    flash_timer = 4;
    hp_trail_delay = 30;

    if (hp <= 0) start_death();

    return true;
}


// Faz o chefe olhar para o jogador
face_player = function()
{
    if (!instance_exists(obj_player)) return;

    var _direction = sign(obj_player.x - x);
    if (_direction != 0) image_xscale = _direction;
}


// Inicia a morte do chefe
start_death = function()
{
    state = BossState.DEAD;
	// --- Teletransporte ---
teleport_timer = 90;
teleport_duration = 25;
appear_duration = 20;
phase_timer = 0;
    death_timer = death_duration;
}


// Atualiza a animação de morte
update_death = function()
{
    death_timer -= 1;
    image_alpha = death_timer / death_duration;

    if (death_timer <= 0) instance_destroy();
}


// Atualiza os efeitos visuais e a barra de vida
update_effects = function()
{
    if (flash_timer > 0) flash_timer -= 1;

    if (hp_trail_delay > 0)
    {
        hp_trail_delay -= 1;
    }
    else
    {
        hp_trail = max(hp_trail - 1, hp);
    }
}

image_yscale = 1.4;