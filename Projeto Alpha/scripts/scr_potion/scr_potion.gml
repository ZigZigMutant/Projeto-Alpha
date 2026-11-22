/// Usa uma carga da poção, se possível
function pocao_usar()
{
    if (healing) return false;
    if (potion_charges <= 0) return false;
    if (hp >= hp_max) return false;
    if (!place_meeting(x, y + 1, obj_chao)) return false;

    potion_charges--;
    healing       = true;
    heal_timer    = 0;
    heal_applied  = false;
    return true;
}

/// Roda todo frame enquanto está bebendo
function pocao_atualizar()
{
    if (!healing) return;

    heal_timer++;

    // a cura entra no meio da animação
    if (!heal_applied && heal_timer >= heal_apply_at)
    {
        hp = min(hp + potion_heal, hp_max);
        heal_applied = true;
        heal_flash = 10;      // frames de brilho
    }

    if (heal_timer >= heal_total)
    {
        healing = false;
    }
}

/// Cancela a bebida (use quando levar dano)
function pocao_interromper()
{
    healing = false;
    heal_timer = 0;
}

/// Chamada pelo altar: devolve todas as cargas
function pocao_recarregar()
{
    potion_charges = potion_max;
}