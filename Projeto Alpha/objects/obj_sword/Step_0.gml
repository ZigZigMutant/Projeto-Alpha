// Acompanha o dono enquanto ele existir
if (instance_exists(owner))
{
    x = owner.x + offset_x;
    y = owner.y + offset_y;
}

// Quando o tempo acabar, a hitbox se destrói sozinha
lifetime -= 1;
if (lifetime <= 0)
{
    instance_destroy();
}