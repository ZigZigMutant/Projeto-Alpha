// ============================================================
// scr_input | Único lugar do projeto que lê teclado
// ============================================================
// Se quiserem trocar as teclas ou adicionar controle (gamepad),
// só este arquivo muda. O resto do jogo usa o struct retornado.

/// @returns {Struct} Estado dos controles neste frame
function input_get()
{
    return {
        move_x:        keyboard_check(ord("D")) - keyboard_check(ord("A")),
        up:            keyboard_check(ord("W")),
        down:          keyboard_check(ord("S")),
        jump_pressed:  keyboard_check_pressed(vk_space),
        melee_pressed: keyboard_check_pressed(ord("K")),
        shoot_pressed: keyboard_check_pressed(ord("J")),
        dash_pressed:  keyboard_check_pressed(vk_shift),
        heal_pressed:  keyboard_check_pressed(ord("L")),
        interact_pressed: keyboard_check_pressed(ord("E")),
		
		 // Controles dos menus
        menu_up_pressed:  keyboard_check_pressed(vk_up),
        menu_down_pressed:keyboard_check_pressed(vk_down),
        confirm_pressed:  keyboard_check_pressed(vk_enter),
        pause_pressed:    keyboard_check_pressed(vk_escape)
    };
}
