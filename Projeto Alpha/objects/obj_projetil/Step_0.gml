// 1. Faz o projétil se movimentar para a frente (multiplicando pela direção 1 ou -1)
x += vshoot * way;

// Faz o sprite do tiro virar para o mesmo lado que o player atirou
image_xscale = way;

//Destrói o tiro se ele bater em uma parede 
if (place_meeting(x , y, COLLISION_OBJECT)) 
{
    instance_destroy();
}

//Destrói o tiro se ele sair da tela para não gastar memória
if (x < 0 || x > room_width || y < 0 || y > room_height) 
{
    instance_destroy();
}