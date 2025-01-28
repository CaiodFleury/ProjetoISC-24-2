#Configurações:
Music_config: 	.word 130,0,28,30  #notas total, nota atual, instrumento, volume	
garden_matriz_x:.half 88, 124, 160, 196, 232
garden_matriz_y:.half 148,120, 92
selectframeads:	.word 0xFF200604

arrow_pos:	.half 4
mosq1_pos:	.half 0,100
sprite_macaco: .byte 3
game_moment: .byte 0
level: .byte 0

vidas: .byte 3

#variaveis inicializaveis
bananatotal: .byte 0
var: .word 0
char_pos:		.half 100, 120
old_char_pos:	.half 200, 0
indio_pos:	.half 300, 48, 0, 0	#posição x, posição y, contador de esq dir, controlador de velocidade
old_indio_pos:	.half 160, 48
indio_pos2: 	.half 300,48,97,58,254,50
garden_state: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
garden_time: .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1