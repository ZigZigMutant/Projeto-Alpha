// 'other' é o inimigo atingido. Se o golpe valeu, o projétil se destrói
if (other.take_hit(8))
{
    instance_destroy();
}