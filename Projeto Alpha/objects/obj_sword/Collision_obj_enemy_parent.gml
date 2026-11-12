// 'other' é o inimigo atingido. Se o golpe valeu, a hitbox se destrói
if (other.take_hit(10))
{
    instance_destroy();
}