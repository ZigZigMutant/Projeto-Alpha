// 'other' é o inimigo atingido. Se o golpe valeu, a hitbox se destrói.
// Passamos o x da espada para o inimigo saber de que lado veio o empurrão.
if (other.take_hit(damage, x))
{
    // Avisa o dono da espada que acertou (é isso que ativa o pogo)
    if (instance_exists(owner))
    {
        owner.on_sword_hit(attack_dir);
    }

    instance_destroy();
}
