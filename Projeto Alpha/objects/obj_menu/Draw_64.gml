
// Desenha a imagem de fundo do menu
draw_sprite_ext(
    spr_menu_background,
    0,
    250,
    145,
    500 / sprite_get_width(spr_menu_background),
    290 / sprite_get_height(spr_menu_background),
    0,
    c_white,
    1
);

// Configura a fonte
draw_set_font(fnt_menu);

// Configura o alinhamento dos textos
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// Desenha a opção New Game
if (menu_selection == 0)
{
    draw_set_color(c_yellow);
    draw_text(25, 220, "> New Game");
}
else
{
    draw_set_color(c_white);
    draw_text(25, 220, "  New Game");
}

// Desenha a opção Exit
if (menu_selection == 1)
{
    draw_set_color(c_yellow);
    draw_text(25, 255, "> Exit");
}
else
{
    draw_set_color(c_white);
    draw_text(25, 255, "  Exit");
}

// Restaura as configurações de desenho
draw_set_font(-1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
