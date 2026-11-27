// Núcleo do projétil
draw_set_color(make_color_rgb(100, 20, 160));
draw_circle(x, y, radius, false);

// Brilho interno
draw_set_color(make_color_rgb(190, 100, 255));
draw_circle(x, y, radius * 0.5, false);

// Restaura a cor
draw_set_color(c_white);