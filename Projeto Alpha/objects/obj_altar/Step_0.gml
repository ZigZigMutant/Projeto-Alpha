// ============================================================
// obj_altar | STEP
// ============================================================
// A dica aparece com o jogador livre, sobre a área do altar
prompt_visible = instance_exists(obj_player)
    && obj_player.state == PlayerState.FREE
    && place_meeting(x, y, obj_player);