// ============================================================
// scr_config | Constantes globais do projeto
// ============================================================

// Objeto usado como sólido em todas as colisões.
// Quando criarem um par_solid (pai de chão, paredes, plataformas),
// basta trocar aqui e todo o jogo passa a usá-lo.
#macro COLLISION_OBJECT obj_chao

// --- Enums ---
// IMPORTANTE: vocês já têm esses enums em algum script.
// NÃO duplique. Apenas adicione HURT e DEAD ao PlayerState existente:
//
// enum PlayerState { FREE, ATTACKING, DASH, HURT, DEAD, HEAL, MEDITATE }
// enum AttackDirection { FORWARD, UP, DOWN }

// Este é novo, pode ficar aqui mesmo:
enum EnemyState { PATROL, CHASE, ATTACK, HURT, DEAD }
