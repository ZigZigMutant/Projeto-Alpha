// Dimensões da interface
var _w = display_get_gui_width();
var _h = display_get_gui_height();

var _x1 = floor((_w - bar_width) / 2);
var _y1 = _h - bar_margin_bottom - bar_height;
var _x2 = _x1 + bar_width - 1;
var _y2 = _y1 + bar_height - 1;

// Largura proporcional à vida
var _hp_width = floor(bar_width * clamp(hp / hp_max, 0, 1));
var _trail_width = floor(bar_width * clamp(hp_trail / hp_max, 0, 1));

// Fundo escuro
draw_set_color(make_color_rgb(20, 8, 12));
draw_rectangle(_x1, _y1, _x2, _y2, false);

// Barra de vida temporária (rastro do dano)
if (_trail_width > 0)
{
    draw_set_color(make_color_rgb(100, 35, 35));
    draw_rectangle(_x1, _y1, _x1 + _trail_width - 1, _y2, false);
}

// Vida atual
if (_hp_width > 0)
{
    draw_set_color(make_color_rgb(145, 15, 20));
    draw_rectangle(_x1, _y1, _x1 + _hp_width - 1, _y2, false);

    // Leve iluminação na parte superior
    draw_set_color(make_color_rgb(190, 35, 35));
    draw_rectangle(_x1, _y1, _x1 + _hp_width - 1, _y1, false);
}

// Contorno envelhecido
draw_set_color(make_color_rgb(105, 75, 55));
draw_rectangle(_x1 - 1, _y1 - 1, _x2 + 1, _y2 + 1, true);

// Restaura a cor padrão
draw_set_color(c_white);