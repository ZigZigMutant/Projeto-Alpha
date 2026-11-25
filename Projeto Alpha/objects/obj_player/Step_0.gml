// ============================================================
// obj_player | Step
// ============================================================

input = input_get();

// O que fazer depende do estado atual
switch (state)
{
    case PlayerState.FREE:
        handle_movement();
        handle_dash_input();

        // Cada ação só roda se o estado continuou livre
        if (state == PlayerState.FREE) handle_interact_input();
        if (state == PlayerState.FREE) handle_potion_input();
        if (state == PlayerState.FREE) handle_attack_input();
        if (state == PlayerState.FREE) update_free_animation();
        break;

    case PlayerState.ATTACKING:
        handle_movement();
        update_attack_state();
        break;

    case PlayerState.DASH:
        update_dash_state();
        break;

    case PlayerState.HURT:
        update_hurt_state();
        break;

    case PlayerState.HEAL:
        update_heal_state();
        break;

    case PlayerState.MEDITATE:
        update_meditate_state();
        break;

    case PlayerState.DEAD:
        update_dead_state();
        break;
}

update_dash_cooldown();
update_mana_feedback();
update_invulnerability();
handle_contact_damage();
check_death();

// --- ATALHO DE DEBUG: só existe ao rodar pela IDE, não no executável final ---
if (GM_build_type == "run" && keyboard_check_pressed(ord("R")))
{
    room_restart();
}

// Debug: recarrega poções e mana sem precisar do altar (P)
if (GM_build_type == "run" && keyboard_check_pressed(ord("P")))
{
    restore_potions();
    restore_mana();
}
