// --- FÍSICA E MOVIMENTO ---
spd = 1;                  // Velocidade de perseguição
hspd = 0;
vspd = 0;
grav = 0.3;

// --- VIDA E ESTADOS ---
hp = 30;                  // Vida total do inimigo
hp_max = 30;
estado = "patrulha";      // Estados: "patrulha", "perseguindo", "atacando", "dano", "morto"

// --- DISTÂNCIAS E GATILHOS ---
raio_visao = 220;         // Distância em pixels para o inimigo notar o player
raio_ataque = 1;         // Distância para desferir o golpe
cooldown_ataque = 0;      // Tempo de espera entre os ataques
qual_ataque = 1;          // Alterna entre o ataque 1 e o ataque 2

// --- TEMPO DE STUN / DANO ---
tempo_dano = 0;