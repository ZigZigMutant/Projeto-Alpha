// Só age quando a sala mudou por causa de uma transição
if (state != "changing") exit;

// Posiciona o jogador e devolve a vida que ele tinha
if (instance_exists(obj_player))
{
    obj_player.x = target_x;
    obj_player.y = target_y;
    obj_player.hp = saved_hp;
}

state = "fade_in"; // Agora a tela começa a clarear