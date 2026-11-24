var menu_input = input_get();

// Verifica se o jogador deseja pausar
if (!is_paused)
{
    if (menu_input.pause_pressed)
    {
        is_paused = true;
        menu_selection = 0;

        // Desativa todas as instâncias, exceto o próprio objeto de pausa
        instance_deactivate_all(true);
    }
}
else
{
    // Navegação pelo menu de pausa
    if (menu_input.menu_up_pressed)
    {
        menu_selection = 0;
    }

    if (menu_input.menu_down_pressed)
    {
        menu_selection = 1;
    }

    // Confirma a opção selecionada
    if (menu_input.confirm_pressed)
    {
        if (menu_selection == 0)
        {
            is_paused = false;
            instance_activate_all();
        }
        else if (menu_selection == 1)
        {
            room_goto(RoomMenu);
        }
    }
}