
// O comportamento vem do obj_enemy_parent.

event_inherited();

// --- Vida ---
hp_max = 30;
hp = hp_max;

// --- Combate ---
damage = 20;                  // Dano por contato no jogador

// --- Movimento ---
spd = 1;                      // Velocidade de patrulha e perseguição

// --- Percepção e ataque ---
sight_radius = 220;
attack_radius = 1;
attack_cooldown_duration = 50;

// --- Sprites ---
sprite_walk = spr_walk_carnical;
sprite_attack = spr_attack_carnical;
sprite_hurt = spr_hurt_carnical;
sprite_death = spr_death_carnical;
