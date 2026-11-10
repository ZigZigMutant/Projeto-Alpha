  // --- 1. APLICAR GRAVIDADE ---
vspd += grav;

// --- 2. DETECÇÃO E TRANSIÇÃO DE ESTADOS ---
if (instance_exists(obj_player) && estado != "morto" && estado != "dano") 
{
    var _dist = distance_to_object(obj_player);
    
    // Se o player entrar no raio de visão, persegue
    if (_dist <= raio_visao) 
    {
        estado = "perseguindo";
    } 
    else 
    {
        estado = "patrulha";
    }
    
    // Se estiver perto o suficiente, muda para o estado de ataque
    if (_dist <= raio_ataque) 
    {
        estado = "atacando";
    }
}

// --- 3. MÁQUINA DE ESTADOS (ANIMAÇÕES E COMPORTAMENTO) ---
switch (estado) 
{
    // A. PATRULHA (Andando casualmente)
    case "patrulha":
        hspd = spd;
        sprite_index = spr_walk_carnical; // Use o sprite de rastejar/andar correspondente
        image_speed = 1;
        
        // Se bater na parede, inverte a direção
        if (place_meeting(x + hspd, y, obj_chao)) 
        {
            hspd = -hspd
        }
        x += hspd;
        
        // Direção do sprite baseada no movimento
        if (hspd != 0) image_xscale = sign(hspd);
        break;
        
    // B. PERSEGUINDO (Indo atrás do jogador)
    case "perseguindo":
        if (instance_exists(obj_player)) 
        {
            // Define se vai para a esquerda ou direita com base na posição do player
            if (obj_player.x < x) 
            {
                hspd = -spd;
            } 
            else 
            {
                hspd = spd;
            }
            
            // Olha para o player
            image_xscale = sign(hspd);
            if (image_xscale == 0) image_xscale = 1;
        }
        
        sprite_index = spr_walk_carnical; 
        image_speed = 1.3; // Um pouco mais rápido ao perseguir
        
        // Colisão horizontal simples na perseguição
        if (place_meeting(x + hspd, y, obj_chao)) 
        {
            hspd = 0;
        }
        x += hspd;
        break;
        
    // C. ATACANDO (Alternando entre Ataque 1 e Ataque 2)
    case "atacando":
        hspd = 0; // Para de andar ao desferir o golpe
        
        // Controla o intervalo (cooldown) entre os ataques
        if (cooldown_ataque > 0) 
        {
            cooldown_ataque -= 1;
        } 
        else 
        {
            // Alterna entre as duas animações de ataque
            if (qual_ataque == 1) 
            {
                sprite_index = spr_attack_carnical; 
                qual_ataque = 2; // Prepara para usar o segundo na próxima vez
            } 
            else 
            {
                sprite_index = spr_attack_carnical; 
                qual_ataque = 1; // Reseta para o primeiro
            }
            
            image_index = 0;     // Reinicia o frame do sprite de ataque escolhido
            image_speed = 1;
            cooldown_ataque = 50; // Quantidade de frames que ele espera até poder atacar novamente
        }
        
        // Quando a animação atual de ataque chega ao fim, ele volta a perseguir
        if (image_index >= image_number - 1) 
        {
            estado = "perseguindo";
        }
        break;
        
    // D. DANO (Sofrendo golpe do player)
    case "dano":
        hspd = 0;
        sprite_index = spr_hurt_carnical; // Animação de sofrer dano
        image_speed = 1;
        
        tempo_dano -= 1;
        if (tempo_dano <= 0) 
        {
            estado = "perseguindo"; // Retoma a perseguição após o recuo
        }
        break;
        
    // E. MORTE (HP chegou a zero)
    case "morto":
        hspd = 0;
        sprite_index = spr_death_carnical; // Animação de morte
        image_speed = 1;
        
        // Destrói o objeto permanentemente assim que o último frame da morte terminar
        if (image_index >= image_number - 1) 
        {
            instance_destroy();
        }
        break;
}

// --- 4. COLISÃO VERTICAL (Chão) ---
if (place_meeting(x, y + vspd, obj_chao)) 
{
    while (!place_meeting(x, y + sign(vspd), obj_chao)) 
    {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;

 