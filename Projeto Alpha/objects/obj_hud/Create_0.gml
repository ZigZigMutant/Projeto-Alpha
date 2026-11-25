// Ajusta a área de desenho da interface ao tamanho da câmera (500x290)
display_set_gui_size(500, 290);

// Posição da moldura na tela
bar_x = 8;
bar_y = 8;

// Onde fica a "janela" da moldura e qual o tamanho dela
fill_offset_x = 12;
fill_offset_y = 5;
fill_width = 80;
fill_height = 8;

flask_x = 8;        // Posição do primeiro frasco
flask_y = 26;       // Abaixo da moldura da vida (ajuste olhando a tela)
flask_spacing = 14;

// ============================================================
// obj_hud | CREATE  (acrescente ao final do Create existente)
// ============================================================
mana_bar_w = 60;   // Largura da barra de mana
mana_bar_h = 6;    // Altura da barra de mana