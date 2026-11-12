// O que fazer depende do estado atual
switch (state)
{
    case PlayerState.FREE:
        handle_movement();
        handle_dash_input();

        // Cada ação só roda se o estado continuou livre
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
}

update_dash_cooldown();
handle_contact_damage();
update_invulnerability();
check_death();

// --- ATALHO DE DEBUG: reinicia a sala ---
if (keyboard_check_pressed(ord("R")))
{
    room_restart();
}