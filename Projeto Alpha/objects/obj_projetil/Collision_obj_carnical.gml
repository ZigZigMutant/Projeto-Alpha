// 'other' aqui representa o inimigo que foi atingido pela hitbox
with (other) 
{
    hp -= 8;            // Retira 10 de vida do inimigo (ajuste conforme necessário)
    estado = "dano";     // Manda o inimigo para o estado de dano
    tempo_dano = 10;     // Tempo que ele fica paralisado (stun)
    image_index = 0;     // Reinicia o frame da animação de dano
    
    // Se a vida zerar, muda para o estado de morte
    if (hp <= 0) 
    {
        estado = "morto";
        image_index = 0;
    }
}

// Destroi a hitbox imediatamente após o golpe para não causar dano infinito no mesmo frame
instance_destroy();