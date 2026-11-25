// ============================================================
// obj_death_screen | DRAW GUI
// ============================================================
var _w = display_get_gui_width();
var _h = display_get_gui_height();

// Véu preto escurecendo a tela
draw_set_color(c_black);
draw_set_alpha(fade_alpha);
draw_rectangle(0, 0, _w, _h, false);
draw_set_alpha(1);

// Título e dica, centralizados (origem dos dois sprites: Middle Centre)
draw_sprite_ext(spr_death_title, 0, floor(_w / 2), floor(_h / 2) - 10, 1, 1, 0, c_white, title_alpha);
draw_sprite_ext(spr_death_prompt, 0, floor(_w / 2), floor(_h / 2) + 26, 1, 1, 0, c_white, prompt_alpha);

draw_set_color(c_white);
