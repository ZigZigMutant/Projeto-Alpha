//MOVIMENTO E COLISÃO
move = -keyboard_check(vk_left) + keyboard_check(vk_right);

hspd = move * spd;


if place_meeting(x+hspd, y, obj_chao)
{
	while !place_meeting(x+sign(hspd), y, obj_chao)
	{
		x += sign(hspd);
	}
	hspd = 0;
}

x += hspd;

if place_meeting(x, y+vspd, obj_chao)
{
	while !place_meeting(x, y+sign(vspd), obj_chao)
	{
		y += sign(vspd);
	}
	vspd = 0;
}

y += vspd;

if place_meeting(x, y+1, obj_chao)
{
	if keyboard_check_pressed(vk_up)
	{
		vspd = jumpspd;
	}
}
else
{
	vspd += grav;
}

attack_melee = keyboard_check_pressed(ord("X")); // Tecla X para espada
attack_shoot = keyboard_check_pressed(ord("C")); // Tecla C para tiro

// 1. Inicia o Ataque Corpo a Corpo (X)
if (attack_melee && !attacking) 
{
    attacking = true;
    sprite_index = spr_attack_player; 
    image_index = 0; 
    image_speed = 1; 
    
    var _offset_x = 32 * image_xscale; 
    var _inst = instance_create_layer(x + _offset_x, y, layer, obj_player_hitbox);
    _inst.image_xscale = image_xscale; 
}

// 2. Inicia o Ataque de Tiro (C)
if (attack_shoot && !attacking) 
{
    attacking = true;
    sprite_index = spr_shoot_player; // Sprite do personagem atirando
    image_index = 0; 
    image_speed = 1; 
    
    // Define a posição onde a bala sai (ex: na ponta da arma/na frente do player)
    var _offset_x = 24 * image_xscale; 
    var _projetil = instance_create_layer(x + _offset_x, y, layer, obj_projetil);
    
    // Passa a direção para o projétil ir para o lado certo
    _projetil.direcao = image_xscale; 
}

// 3. Comportamento ENQUANTO estiver atacando (qualquer um dos dois)
if (attacking) 
{
    // Quando a animação do ataque/tiro chegar ao fim, o jogador destrava
    if (image_index >= image_number - 1) 
    {
        attacking = false; 
    }
}
// 4. Comportamento normal (se NÃO estiver atacando)
else 
{
    if (move != 0) 
    {
        sprite_index = spr_run_player;
        image_xscale = move; 
    } 
    else 
    {
        sprite_index = spr_player;
    }
}