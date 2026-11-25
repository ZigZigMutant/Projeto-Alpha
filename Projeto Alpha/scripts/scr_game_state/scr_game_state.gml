// ============================================================
// scr_game_state | Estado global do jogo
// ============================================================
// Código fora de funções, dentro de um script, roda UMA vez ao iniciar o jogo.

// Último altar em que o jogador meditou: { room_id, x, y }. undefined = nenhum ainda.
global.checkpoint = undefined;

// true entre a morte do jogador e o nascimento dele no último altar
global.respawning = false;
