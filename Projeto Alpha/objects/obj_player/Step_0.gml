//MOVIMENTO E COLISÃO
move = -keyboard_check(vk_left) + keyboard_check(vk_right)

hspd = move * spd


if place_meeting(x+hspd, y, obj_chao) //Colisão Horizontal
{
	while !place_meeting(x+sign(hspd), y, obj_chao)
	{
		x += sign(hspd)
	}
	hspd = 0
}

x += hspd

if place_meeting(x, y+vspd, obj_chao)// Colisão Vertical
{
	while !place_meeting(x, y+sign(vspd), obj_chao)
	{
		y += sign(vspd)
	}
	vspd = 0;
}

y += vspd

if place_meeting(x, y+1, obj_chao) // Pulo
{
	if keyboard_check_pressed(vk_up)
	{
		vspd = jumpspd
	}
}
else
{
	vspd += grav
}

//ATAQUE E TIRO

attack_melee = keyboard_check_pressed(ord("X")) // Tecla X para espada
attack_shoot = keyboard_check_pressed(ord("C")) // Tecla C para tiro

//Ataque Corpo a Corpo
if (attack_melee && !attacking) 
{
    attacking = true
    sprite_index = spr_attack_player
    image_index = 0
    image_speed = 1
    
//Cria uma Hitbox
    var _offset_x = 32 * image_xscale 
    var _inst = instance_create_layer(x + _offset_x, y, layer, obj_player_hitbox)
    _inst.image_xscale = image_xscale
}

//Ataque de Tiro
if (attack_shoot && !attacking) 
{
    attacking = true
    sprite_index = spr_shoot_player
    image_index = 0
    image_speed = 1
    
    // Define a posição onde a bala sai 
    var _offset_x = 24 * image_xscale; 
    var _projetil = instance_create_layer(x + _offset_x, y, layer, obj_projetil)
    
    _projetil.way = image_xscale; 
}

//Comportamento ENQUANTO estiver atacando
if (attacking) 
{
  
    if (image_index >= image_number - 1) 
    {
        attacking = false; 
    }
}
//Comportamento normal 
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

// --- LÓGICA DE DANO POR COLISÃO COM INIMIGO ---

// Se não estiver invulnerável e encostar no inimigo
if (!invulnerable && place_meeting(x, y, obj_carnical)) 
{
    hp -= 20            
    invulnerable = true
    time_invulnerable = room_speed * 1 // Fica 1 segundo invulnerável (piscos)
    
    // Opcional: Empurrão (Knockback) ao tomar dano
    vspd = -4
}

// Controla o tempo de invulnerabilidade
if (invulnerable) 
{
    time_invulnerable -= 1;
    if (time_invulnerable <= 0) 
    {
        invulnerable = false;
    }
}

// --- VERIFICAÇÃO DE MORTE ---
if (hp <= 0) 
{
    // O que acontece quando o player morre
    // Exemplo: Reiniciar a fase ou destruir o objeto
    room_restart(); 
}
