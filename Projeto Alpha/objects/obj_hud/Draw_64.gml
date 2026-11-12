// Sem jogador na sala, não há o que mostrar
if (!instance_exists(obj_player)) exit;

// Porcentagem de vida restante, entre 0 e 1
var _ratio = clamp(obj_player.hp / obj_player.hp_max, 0, 1);

// Posição da janela na tela e largura atual do preenchimento
var _fill_x = bar_x + fill_offset_x;
var _fill_y = bar_y + fill_offset_y;
var _current_width = floor(fill_width * _ratio);

// Fundo escuro da janela
draw_set_color(make_color_rgb(20, 8, 12));
draw_rectangle(_fill_x, _fill_y, _fill_x + fill_width - 1, _fill_y + fill_height - 1, false);

if (_current_width > 0)
{
    // Preenchimento vermelho sangue
    draw_set_color(make_color_rgb(150, 20, 30));
    draw_rectangle(_fill_x, _fill_y, _fill_x + _current_width - 1, _fill_y + fill_height - 1, false);

    // Faixa de brilho no topo, para dar volume
    draw_set_color(make_color_rgb(205, 55, 60));
    draw_rectangle(_fill_x, _fill_y, _fill_x + _current_width - 1, _fill_y, false);
}

// Volta ao padrão para não afetar outros desenhos
draw_set_color(c_white);

// Moldura decorativa por cima de tudo
draw_sprite(spr_hp_frame, 0, bar_x, bar_y);