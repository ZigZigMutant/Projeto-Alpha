
 // Comportamento do chefe de acordo com seu estado
switch (state)
{
    // ==========================================
    // ESTADO: IDLE
    // ==========================================
    case BossState.IDLE:

        face_player();
		
		// Verifica se o chefe atingiu 50% da vida
		if (hp <= hp_max * 0.5)
		{
			special_attack_triggered = true;
		}

        // Controla o tempo até desaparecer
        teleport_timer -= 1;

        // Fase 0: prepara e dispara o primeiro projétil
        if (attack_phase == 0)
        {
            attack_timer -= 1;

            if (attack_timer <= 0 && instance_exists(obj_player))
            {
                var _direction = sign(obj_player.x - x);

                if (_direction == 0)
                    _direction = image_xscale;

                // Primeiro disparo: altura fixa
                var _shot = instance_create_layer(
                    x + _direction * 32,
                    y - 20,
                    layer,
                    obj_necro_projectile
                );

                _shot.direction_x = _direction;

                attack_phase = 1;
                projectile_timer = projectile_delay;
            }
        }

        // Fase 1: espera e dispara o segundo projétil
        else if (attack_phase == 1)
        {
            projectile_timer -= 1;

            if (projectile_timer <= 0 && instance_exists(obj_player))
            {
                var _direction = sign(obj_player.x - x);

                if (_direction == 0)
                    _direction = image_xscale;

                // Segundo disparo: mira na altura atual do 
					var _shot_y = y - 100;

                var _shot = instance_create_layer(
                    x + _direction * 32,
                    _shot_y,
                    layer,
                    obj_necro_projectile
                );

                _shot.direction_x = _direction;

                // Os dois disparos foram realizados
                attack_phase = 2;
            }
        }

        // Desaparece quando o tempo acaba
        if (teleport_timer <= 0)
        {
            state = BossState.HIDDEN;
            phase_timer = teleport_duration;
        }

        break;


    // ==========================================
    // ESTADO: HIDDEN
    // ==========================================
    case BossState.HIDDEN:

        phase_timer -= 1;

        // Desaparece gradualmente
        image_alpha = phase_timer / teleport_duration;

        if (phase_timer <= 0)
        {
            // Teletransporta para o lado oposto da arena
            if (x < room_width / 2)
                x = room_width - 128;
            else
                x = 128;

            // Verifica se o ataque especial está liberado
			if (special_attack_triggered && !special_attack_started)
			{
		    special_attack_started = true;
		   state = BossState.SPECIAL_ASCENDING;
	   image_alpha = 1;
		}
		else
		{
    state = BossState.APPEARING;
    phase_timer = appear_duration;
    image_alpha = 0;
		}
        }

        break;


    // ==========================================
    // ESTADO: APPEARING
    // ==========================================
    case BossState.APPEARING:

        face_player();

        phase_timer -= 1;

        // Reaparece gradualmente
        image_alpha = 1 - (phase_timer / appear_duration);

        if (phase_timer <= 0)
        {
            image_alpha = 1;
            state = BossState.IDLE;

            // Reinicia os tempos para o próximo ciclo
            teleport_timer = 150;
            attack_timer = 30;
            attack_phase = 0;
        }

        break;


    // ==========================================
    // ESTADO: DEAD
    // ==========================================
    case BossState.DEAD:

        update_death();

        break;


    // ==========================================
    // ESTADO: SPECIAL_ASCENDING
    // ==========================================
    case BossState.SPECIAL_ASCENDING:

        // O chefe sobe até a altura definida
        if (y > special_target_y)
        {
            y -= special_fly_speed;
        }
        else
        {
            y = special_target_y;

            // Próxima etapa: invocar o carniçal
            state = BossState.SPECIAL_CARNICAL;
        }

        break;
		    // ==========================================
    // ESTADO: SPECIAL_CARNICAL
    // ==========================================
    case BossState.SPECIAL_CARNICAL:

        // Invoca o carniçal apenas uma vez
        if (summoned_enemy_1 == noone)
        {
            var _spawn_x = room_width / 2;

            if (instance_exists(obj_player))
            {
                _spawn_x = clamp(
                    obj_player.x + (obj_player.x < room_width / 2 ? 120 : -120),
                    64,
                    room_width - 64
                );
            }

			summoned_enemy_1 = instance_create_layer(
			  _spawn_x,
			  200,
			   layer,
			   obj_carnical
			);
        }
        // Aguarda o carniçal ser derrotado
        else if (!instance_exists(summoned_enemy_1))
        {
            // Próxima onda: dois esqueletos
            state = BossState.SPECIAL_SKELETONS;
        }

        break;
		        // ==========================================
    // ESTADO: SPECIAL_SKELETONS
    // ==========================================
case BossState.SPECIAL_SKELETONS:

    // Invoca os dois esqueletos apenas uma vez
    if (summoned_enemy_2 == noone && summoned_enemy_3 == noone)
    {
        // Posições próximas ao centro da arena
        var _spawn_x1 = room_width * 0.35;
        var _spawn_x2 = room_width * 0.65;

        // Invoca os esqueletos
        summoned_enemy_2 = instance_create_layer(
            _spawn_x1,
            200,
            layer,
            obj_esqueleto
        );

        summoned_enemy_3 = instance_create_layer(
            _spawn_x2,
            200,
            layer,
            obj_esqueleto
        );
    }
    else if (
        !instance_exists(summoned_enemy_2) &&
        !instance_exists(summoned_enemy_3)
    )
    {
        state = BossState.SPECIAL_DESCENDING;
    }

    break;
	
	case BossState.SPECIAL_DESCENDING:

    // Desce em direção à posição original
    y = min(y + special_fly_speed, special_ground_y);

    // Quando chegar ao chão, retoma o combate
    if (y >= special_ground_y)
    {
        y = special_ground_y;
        state = BossState.IDLE;

        // Reinicia o ciclo de combate
        teleport_timer = 150;
        attack_timer = 30;
        attack_phase = 0;
    }

    break;
}


// Atualiza os efeitos visuais
update_effects();
