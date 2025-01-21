#Configurações:
Music_config: 	.word 130,0,28,30  #notas total, nota atual, instrumento, volume	
Time_line: 	.word 0,0 #playerTime, arrowTime
char_pos:	.half 100, 120
old_char_pos:	.half 200, 0
arrow_pos:	.half 4
indio_pos:	.half 300, 32, 0
old_indio_pos:	.half 160, 32
char_pos_bounds:.half 84, 240, 232, 64
selectframeads:	.word 0xFF200604
garden_matriz_x:.half 88, 124, 160, 196, 232
garden_matriz_y:.half 148,120, 92
var: .word 28

# a logica se consiste na equacao:
# 88 + (36 * x)
# 148 - (28 * y)

# matriz que representa o estado do jardim (quao regado ele esta)
garden_state: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
