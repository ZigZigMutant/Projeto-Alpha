var menu_input = input_get();

// Navegação para cima
if (menu_input.menu_up_pressed)
{
    menu_selection = 0;
}

// Navegação para baixo
if (menu_input.menu_down_pressed)
{
    menu_selection = 1;
}

// Confirma a opção selecionada
if (menu_input.confirm_pressed)
{
    if (menu_selection == 0)
    {
        room_goto(Room1);
    }
    else if (menu_selection == 1)
    {
        game_end();
    }
}