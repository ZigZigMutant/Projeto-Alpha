// 'other' é o inimigo atingido. Se o golpe valeu, a hitbox se destrói
if (other.take_hit(10))
{
    // Avisa o dono da espada que acertou (é isso que ativa o pogo)
    if (instance_exists(owner))
    {
        owner.on_sword_hit(attack_dir);
    }

    instance_destroy();
}