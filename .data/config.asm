#Configurações:
Music_config: 	.word 130,0,28,30  #notas total, nota atual, instrumento, volume	
Time_line: 	.word 0,0 #playerTime, arrowTime
char_pos:	.half 100, 120
old_char_pos:	.half 200, 0
arrow_pos:	.half 4
indio_pos:	.half 48, 100
char_pos_bounds:.half 80, 240, 232, 64
selectframeads:	.word 0xFF200604
garden_matriz_x:.half 72, 116, 160, 204, 248
garden_matriz_y:.half 160,120, 80

# a logica se consiste na equacao:
# 72 + (44 * x)
# 160 - (40 * y)
# desse modo, podemos saber a coordenada do jardim de acordo com esse indice
current_garden_x:.byte 0
current_garden_y:.byte 0

# matriz que representa o estado do jardim (quao regado ele esta)
garden_state_x: .byte 0, 0, 0, 0, 0
garden_state_y: .byte 0, 0, 0
