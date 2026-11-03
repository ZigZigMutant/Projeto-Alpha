// 1. Faz o projétil se movimentar para a frente (multiplicando pela direção 1 ou -1)
x += vshoot * way;

// 2. Faz o sprite do tiro virar para o mesmo lado que o player atirou
image_xscale = way;

// 3. Destrói o tiro se ele bater em uma parede (obj_chao)
if (place_meeting(x, y, obj_chao)) 
{
    instance_destroy();
}

// 4. (Opcional) Destrói o tiro se ele sair da tela para não gastar memória
if (x < 0 || x > room_width || y < 0 || y > room_height) 
{
    instance_destroy();
}