// ============================================================
// obj_death_screen | CREATE
// ============================================================
// Criado pelo jogador ao morrer (depth -10000, acima de tudo).
owner = noone;          // O jogador que morreu (ele preenche isso)

// Tempos, em frames
fade_duration = 90;     // Tela escurecendo até o preto total
title_delay = 20;       // Pausa no preto antes do título
title_fade = 70;        // Fade-in do título
prompt_delay = 50;      // Pausa depois do título, antes da dica
prompt_fade = 30;       // Fade-in da dica

// Em que frame cada etapa começa
title_start = fade_duration + title_delay;
prompt_start = title_start + title_fade + prompt_delay;

timer = 0;
fade_alpha = 0;
title_alpha = 0;
prompt_alpha = 0;
used = false;           // Impede apertar R duas vezes
