// Estados possíveis do jogador
enum PlayerState
{
    FREE,
    ATTACKING,
    DASH,
	HURT,
	DEAD,
	HEAL
}

// Direções possíveis do golpe de espada
enum AttackDirection
{
    FORWARD,
    UP,
    DOWN
}