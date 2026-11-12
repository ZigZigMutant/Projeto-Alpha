// --- 1. APLICAR GRAVIDADE ---
vspd += grav;

// --- 2. DETECÇÃO E TRANSIÇÃO DE ESTADOS ---
if (instance_exists(obj_player) && state != "dead" && state != "hurt")
{
    var _dist = distance_to_object(obj_player);

    // Se o jogador entrar no raio de visão, persegue
    if (_dist <= sight_radius)
    {
        state = "chase";
    }
    else
    {
        state = "patrol";
    }

    // Se estiver perto o suficiente, muda para o estado de ataque
    if (_dist <= attack_radius)
    {
        state = "attack";
    }
}

// --- 3. MÁQUINA DE ESTADOS (ANIMAÇÕES E COMPORTAMENTO) ---
switch (state)
{
    // A. PATRULHA
    case "patrol":
        hspd = spd;
        sprite_index = spr_walk_carnical;
        image_speed = 1;

        // Se bater na parede, inverte a direção
        if (place_meeting(x + hspd, y, obj_chao))
        {
            hspd = -hspd;
        }
        x += hspd;

        // Direção do sprite baseada no movimento
        if (hspd != 0) image_xscale = sign(hspd);
        break;

    // B. PERSEGUINDO
    case "chase":
        if (instance_exists(obj_player))
        {
            // Define se vai para a esquerda ou direita com base na posição do jogador
            if (obj_player.x < x)
            {
                hspd = -spd;
            }
            else
            {
                hspd = spd;
            }

            // Olha para o jogador
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

    // C. ATACANDO
    case "attack":
        hspd = 0; // Para de andar ao desferir o golpe

        // Controla o intervalo entre os ataques
        if (attack_cooldown > 0)
        {
            attack_cooldown -= 1;
        }
        else
        {
            // Alterna entre as duas animações de ataque
            if (attack_index == 1)
            {
                sprite_index = spr_attack_carnical;
                attack_index = 2;
            }
            else
            {
                sprite_index = spr_attack_carnical;
                attack_index = 1;
            }

            image_index = 0;       // Reinicia o frame do sprite de ataque
            image_speed = 1;
            attack_cooldown = 50;  // Frames de espera até poder atacar de novo
        }

        // Quando a animação de ataque termina, volta a perseguir
        if (image_index >= image_number - 1)
        {
            state = "chase";
        }
        break;

    // D. DANO
    case "hurt":
        hspd = 0;
        sprite_index = spr_hurt_carnical;
        image_speed = 1;

        hurt_timer -= 1;
        if (hurt_timer <= 0)
        {
            state = "chase"; // Retoma a perseguição após o stun
        }
        break;

    // E. MORTE
    case "dead":
        hspd = 0;
        sprite_index = spr_death_carnical;
        image_speed = 1;

        // Destrói o objeto quando o último frame da morte terminar
        if (image_index >= image_number - 1)
        {
            instance_destroy();
        }
        break;
}

// --- 4. COLISÃO VERTICAL (CHÃO) ---
if (place_meeting(x, y + vspd, obj_chao))
{
    while (!place_meeting(x, y + sign(vspd), obj_chao))
    {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;