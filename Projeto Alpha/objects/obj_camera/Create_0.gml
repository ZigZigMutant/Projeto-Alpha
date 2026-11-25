// Criar câmera
cam = camera_create();

// Resolução da câmera
view_w = 500;
view_h = 285;
// Altura fixa da câmera


camera_fixed_y = 0;

camera_set_view_size(cam, view_w, view_h);

// Ativar viewport
view_enabled = true;
view_visible[0] = true;
view_camera[0] = cam;

// Velocidade de acompanhamento
camera_speed = 0.10;

// Configuração padrão
if (!variable_global_exists("camera_vertical"))
{
    global.camera_vertical = false;
}

// Zona morta vertical
dead_zone_top = 140;
dead_zone_bottom = 260
;