// No Evento Step da hitbox
tempo_vida -= 1;

// Se o tempo acabar, a hitbox se destrói sozinha
if (tempo_vida <= 0) 
{
    instance_destroy();
}