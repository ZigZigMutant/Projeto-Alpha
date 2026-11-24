
// Só desenha o menu quando o jogo estiver pausado
if (is_paused)
{
    // Desenha uma camada escura sobre o jogo
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, 500, 290, false);

    // Configura a fonte e o alinhamento
    draw_set_alpha(1);
    draw_set_font(fnt_menu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Desenha o título
    draw_set_color(c_white);
    draw_text(250, 90, "PAUSED");

    // Opção Resume
    if (menu_selection == 0)
    {
        draw_set_color(c_yellow);
    }
    else
    {
        draw_set_color(c_white);
    }

    draw_text(250, 150, "Resume");

    // Opção Main Menu
    if (menu_selection == 1)
    {
        draw_set_color(c_yellow);
    }
    else
    {
        draw_set_color(c_white);
    }

    draw_text(250, 190, "Main Menu");

    // Restaura as configurações de desenho
    draw_set_font(-1);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
