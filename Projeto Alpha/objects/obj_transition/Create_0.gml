persistent = true; // Sobrevive à troca de sala

state = "idle";    // Estados: "idle", "fade_out", "changing", "fade_in"
alpha = 0;         // 0 = tela normal, 1 = tela totalmente preta
fade_speed = 0.04; // Quanto o alpha muda por frame

target_room = noone;
target_x = 0;
target_y = 0;
saved_hp = 0;

// Inicia a transição (chamada pelas portas)
begin_transition = function(_room, _x, _y)
{
    // Ignora se já existe uma transição em andamento
    if (state != "idle") return;

    target_room = _room;
    target_x = _x;
    target_y = _y;
    state = "fade_out";
}