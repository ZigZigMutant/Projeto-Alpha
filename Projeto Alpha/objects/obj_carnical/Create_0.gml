event_inherited(); // Executa primeiro o Create do obj_enemy_parent

// --- FÍSICA E MOVIMENTO ---
spd = 1;                  // Velocidade de perseguição
hspd = 0;
vspd = 0;
grav = 0.3;

// --- VIDA E ESTADOS ---
hp = 30;
hp_max = 30;
state = "patrol";         // Estados: "patrol", "chase", "attack", "hurt", "dead"

// --- DISTÂNCIAS E GATILHOS ---
sight_radius = 220;       // Distância em pixels para o inimigo notar o jogador
attack_radius = 1;        // Distância para desferir o golpe
attack_cooldown = 0;      // Tempo de espera entre os ataques
attack_index = 1;         // Alterna entre o ataque 1 e o ataque 2

// --- COMBATE ---
damage = 20;              // Dano causado ao jogador por contato