//Sistema de Vida
hp_max = 100 
hp = hp_max  

//Controle de dano 
invulnerable = false
time_invulnerable = 0

//Movimento
hspd=0
vspd=0
spd=3
grav=0.75
jumpspd=-12
facing=1
knockback_x = 0

//Ataque
attacking= false

//Checagem de morte
check_death = function()
{
    if (hp <= 0)
    {
        room_restart();
    }
}

// Controla o tempo de invulnerabilidade
update_invulnerability = function()
{
	if (invulnerable) 
	{
	 time_invulnerable -= 1;
	 if (time_invulnerable <= 0) 
	 {
	     invulnerable = false;
	 }
	}
}

// --- LÓGICA DE DANO POR COLISÃO COM INIMIGO ---
// Função para deixar invencível independente do dano que tomar
take_damage = function(_amount, _source_x)
{
    // Se já está invulnerável, ignora o dano e encerra a função
    if (invulnerable) return;

    hp -= _amount;                      
    invulnerable = true;            
    time_invulnerable = room_speed * 1;  

    // Direção do empurrão: para longe de quem causou o dano
    var _direction = sign(x - _source_x);
    if (_direction == 0) _direction = -image_xscale; // Se estiverem no mesmo X, empurra para trás do jogador

    knockback_x = _direction * 6; 
    vspd = -2;         
}
// Tomar dano e ativar a logica da linha anterior
var _enemy = instance_place(x, y, obj_enemy_parent);
if (_enemy != noone)
{
    take_damage(_enemy.damage);
}