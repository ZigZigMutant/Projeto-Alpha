//ANDAR
move = -keyboard_check(vk_left) +keyboard_check(vk_right)

hspd = move*spd

if place_meeting(x+hspd,y,obj_chao)
{
	while !place_meeting(x+sign(hspd),y,obj_chao)
	{
		x+=sign(hspd)
	}
	hspd = 0
}

x+= hspd

if place_meeting(x,y+vspd,obj_chao)
{
	while !place_meeting(x,y+sign(vspd),obj_chao)
	{
		y+=sign(vspd)
	}
	vspd = 0
}

y+= vspd

if place_meeting(x,y+1,obj_chao)
{
	if keyboard_check_pressed(vk_up)
	{
		vspd=jumpspd
	}
}
else
{
	vspd+=grav
}
