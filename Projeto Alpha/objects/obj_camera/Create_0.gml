cam = view_camera[0];
cam_w = camera_get_view_width(cam);
cam_h = camera_get_view_height(cam);

follow_speed = 0.1;   // 0 = não se move, 1 = cola no jogador
offset_y = -130;       // Mira no corpo do jogador (a origem dele fica nos pés)

cam_x = 0;
cam_y = 0;
snapped = false;      // Na primeira vez, pula direto para o jogador
// Limites da câmera nesta sala (sobrescreva na Creation Code da instância)
bound_left = 0;
bound_top = 0;
bound_right = room_width;
bound_bottom = room_height;