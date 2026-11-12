// --- VALORES PADRÃO (cada inimigo sobrescreve os seus) ---
hp = 1;
hp_max = 1;
state = "patrol";
hurt_timer = 0;
damage = 0;

// --- RECEBER UM GOLPE ---
// Devolve true se o golpe foi aplicado e false se foi ignorado
take_hit = function(_amount)
{
    // Inimigo já morrendo não recebe mais golpes
    if (state == "dead") return false;

    hp -= _amount;
    state = "hurt";
    hurt_timer = 10;   // Tempo de stun
    image_index = 0;   // Reinicia a animação de dano

    // Se a vida zerou, vai para o estado de morte
    if (hp <= 0)
    {
        state = "dead";
        image_index = 0;
    }

    return true;
}