// ============================================================
// scr_config | Constantes globais do projeto
// ============================================================

// Objeto usado como sólido em todas as colisões.
// Quando criarem um par_solid (pai de chão, paredes, plataformas),
// basta trocar aqui e todo o jogo passa a usá-lo.
#macro COLLISION_OBJECT par_solid

// Sala onde a fase começa: para lá o jogador volta ao morrer sem ter achado um altar.
// room_first é a primeira sala da lista de rooms do projeto. Quando existir um menu
// inicial como primeira room, troque pelo nome da primeira sala da fase (ex.: rm_fase1).
#macro LEVEL_START_ROOM Room1

// --- Enums ---
// IMPORTANTE: vocês já têm esses enums em algum script.
// NÃO duplique. Apenas adicione HURT e DEAD ao PlayerState existente:
//
// enum PlayerState { FREE, ATTACKING, DASH, HURT, DEAD, HEAL, MEDITATE }
// enum AttackDirection { FORWARD, UP, DOWN }

// Este é novo, pode ficar aqui mesmo:
enum EnemyState { PATROL, CHASE, ATTACK, HURT, DEAD }
