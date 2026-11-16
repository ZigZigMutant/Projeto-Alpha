// ============================================================
// obj_enemy_parent | Step
// ============================================================
// Os filhos herdam este Step. Se um filho precisar de Step próprio,
// ele deve chamar event_inherited() no início.

update_attack_cooldown();
update_perception();

switch (state)
{
    case EnemyState.PATROL: update_patrol(); break;
    case EnemyState.CHASE:  update_chase();  break;
    case EnemyState.ATTACK: update_attack(); break;
    case EnemyState.HURT:   update_hurt();   break;
    case EnemyState.DEAD:   update_dead();   break;
}

move_vertical();
