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

// Frascos de cura: cheio para cada carga, vazio para as gastas
for (var i = 0; i < obj_player.potion_max; i++)
{
    var _sprite = (i < obj_player.potion_charges) ? spr_flask_full : spr_flask_empty;
    draw_sprite(_sprite, 0, flask_x + i * flask_spacing, flask_y);
}

// ============================================================
// obj_hud | DRAW  (cole ANTES do draw_set_color(c_white) final)
// ============================================================
// Usa flask_x, flask_y e flask_spacing, definidos para as poções:
// a moldura fica à direita dos frascos, na mesma linha.

var _player = obj_player;
var _fx = flask_x + _player.potion_max * flask_spacing + 2;   // Canto da moldura
var _fy = flask_y;
var _mx = _fx + mana_win_x;                                   // Canto da janela
var _my = _fy + mana_win_y;
var _mana_w = floor(mana_bar_w * clamp(_player.mana / _player.mana_max, 0, 1));

// Cor da barra: pisca em vermelho se faltou mana, brilha ao ganhar mana
var _fill = make_color_rgb(54, 112, 214);
var _shine = make_color_rgb(128, 184, 255);
if (_player.mana_flash_timer > 0 && (_player.mana_flash_timer div 3) mod 2 == 0)
{
    _fill = make_color_rgb(190, 50, 56);
    _shine = make_color_rgb(235, 110, 110);
}
else if (_player.mana_gain_timer > 0)
{
    _fill = make_color_rgb(110, 170, 250);
    _shine = make_color_rgb(210, 235, 255);
}

// Fundo da janela
draw_set_color(make_color_rgb(10, 16, 34));
draw_rectangle(_mx, _my, _mx + mana_bar_w - 1, _my + mana_bar_h - 1, false);

// Preenchimento com faixa de brilho no topo
if (_mana_w > 0)
{
    draw_set_color(_fill);
    draw_rectangle(_mx, _my, _mx + _mana_w - 1, _my + mana_bar_h - 1, false);
    draw_set_color(_shine);
    draw_rectangle(_mx, _my, _mx + _mana_w - 1, _my, false);
}

// Marcas: cada divisão equivale a um tiro (alinhadas às marcas dos trilhos)
draw_set_color(make_color_rgb(14, 9, 12));
for (var i = 1; i < _player.mana_max / _player.shoot_cost; i++)
{
    var _tx = _mx + floor(mana_bar_w * i * _player.shoot_cost / _player.mana_max);
    draw_line(_tx, _my, _tx, _my + mana_bar_h - 1);
}

// Moldura por cima de tudo (a janela dela é transparente)
draw_set_color(c_white);
draw_sprite(spr_mana_frame, 0, _fx, _fy);


// Volta ao padrão para não afetar outros desenhos

draw_set_color(c_white);

// Moldura decorativa por cima de tudo
draw_sprite(spr_hp_frame, 0, bar_x, bar_y);