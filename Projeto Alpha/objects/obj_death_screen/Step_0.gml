// ============================================================
// obj_death_screen | STEP
// ============================================================
timer += 1;

fade_alpha = clamp(timer / fade_duration, 0, 1);
title_alpha = clamp((timer - title_start) / title_fade, 0, 1);
prompt_alpha = clamp((timer - prompt_start) / prompt_fade, 0, 1);

// Só dá para ressurgir depois que a dica aparece por completo
if (!used && prompt_alpha >= 1 && input_get().respawn_pressed && instance_exists(owner))
{
    used = true;
    owner.respawn();
}

