// Sprite padrão: spr_altar (velas tremulando). Origem nos pés, no centro.
image_speed = 1;

// Onde o jogador renasce depois de morrer (o chão em frente ao altar).
// Para mudar numa sala específica, use o Creation Code da instância.
respawn_x = x;
respawn_y = y;

prompt_visible = false;   // Mostra a tecla E quando o jogador pode meditar

// Chamada pelo jogador no auge da meditação: a cruz acende
activate = function()
{
    sprite_index = spr_altar_active;
    image_index = 0;
    image_speed = 1;
}
