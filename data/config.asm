#Configurações:
Music_config: 	.word 37,0,1,60  #notas total, nota atual, instrumento, volume	
garden_matriz_x:.half 82, 116, 150, 186, 220
garden_matriz_y:.half 134, 108, 86
selectframeads:	.word 0xFF200604

arrow_pos:	.half 4

sprite_macaco: .byte 3
game_moment: .byte 0
level: .byte 1

vidas: .byte 3
pontostotais: 	.word 0
relogio_pos: .byte -1
power_control: .word 0, 0

#variaveis inicializaveis
bananatotal: 	.byte 0
var:        	.word 0
indio_pos2: 	.half 168,48,100,59,252,53
mosq1_posy:	.half -4,140
garden_state:   .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
garden_time:    .word -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
temp:           .word 0, 0, 0
tempo_sobrando: .word 0


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
