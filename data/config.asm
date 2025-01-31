#Configurações:
Music_config: 	.word 130,0,28,30  #notas total, nota atual, instrumento, volume	
garden_matriz_x:.half 88, 124, 160, 196, 232
garden_matriz_y:.half 148,120, 92
selectframeads:	.word 0xFF200604

arrow_pos:	.half 4

sprite_macaco: .byte 3
game_moment: .byte 0
level: .byte 0

vidas: .byte 3

relogio_pos: .byte -1

#variaveis inicializaveis
bananatotal: 	.byte 0
var:        	.word 0
indio_pos2: 	.half 168,48,100,59,252,53
mosq1_posy:	.half -4,140
garden_state:   .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
garden_time:    .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1

#SuperRenderv1
RenderObjFirst:
Obj1:		.word 0,0,0,0,0,0,0
Obj2:		.word 0,0,0,0,0,0,0
Obj3:		.word 0,0,0,0,0,0,0
Obj4:		.word 0,0,0,0,0,0,0
Obj5:		.word 0,0,0,0,0,0,0
Obj6:		.word 0,0,0,0,0,0,0
Obj7:		.word 0,0,0,0,0,0,0
Obj8:		.word 0,0,0,0,0,0,0
Obj9:		.word 0,0,0,0,0,0,0
Obj10:		.word 0,0,0,0,0,0,0
