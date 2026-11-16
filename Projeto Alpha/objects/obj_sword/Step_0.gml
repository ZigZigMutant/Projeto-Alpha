// Sem dono, não existe golpe
if (!instance_exists(owner))
{
    instance_destroy();
    exit;
}

// Acompanha o dono
x = owner.x + offset_x;
y = owner.y + offset_y;

// Quando o tempo acabar, a hitbox se destrói sozinha
lifetime -= 1;
if (lifetime <= 0)
{
    instance_destroy();
}
