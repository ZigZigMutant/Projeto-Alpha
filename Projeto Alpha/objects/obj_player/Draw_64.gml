// --- DESENHAR INTERFACE DE VIDA (UI) ---

var _x = 32; // Posição X na tela
var _y = 32; // Posição Y na tela
var _largura_barra = 200; // Tamanho máximo da barra em pixels
var _altura_barra = 20;   // Altura da barra

// Calcula a porcentagem de vida restante (entre 0 e 1)
var _porcentagem_hp = hp / hp_max;

// Desenha o fundo da barra (cinza/preto)
draw_set_color(c_dkgray);
draw_rectangle(_x, _y, _x + _largura_barra, _y + _altura_barra, false);

// Desenha a barra de vida atual (verde proporcional ao HP)
draw_set_color(c_lime);
draw_rectangle(_x, _y, _x + (_largura_barra * _porcentagem_hp), _y + _altura_barra, false);

// Desenha a borda da barra (branca)
draw_set_color(c_white);
draw_rectangle(_x, _y, _x + _largura_barra, _y + _altura_barra, true);

// Reseta a cor padrão do GameMaker para não bugar outros desenhos
draw_set_color(c_white);