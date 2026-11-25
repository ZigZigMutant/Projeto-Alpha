// ============================================================
// obj_altar | DRAW
// ============================================================
draw_self();

if (prompt_visible)
{
    // Tecla E flutuando acima do altar
    var _bob = round(sin(current_time / 180) * 1.5);
    draw_sprite(spr_prompt_interact, 0, x, y - sprite_height - 4 + _bob);
}
