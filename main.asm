.data
selectframeads:	.word 0xFF200604
char_pos:	.half 80, 176
old_char_pos:	.half 80, 176
char_pos_bounds:.half 80, 240, 232, 64
garden_matriz_x:.half 72,116, 160 , 204, 248
garden_matriz_y:.half 160,120, 80
#array_layers:	.byte 0xC7:460800
Music_config: 	.word 72,0,90,30 #notas total, nota atual, instrumento, volume
Notas: 76,400,75,200,76,600,75,200,76,400,69,200,72,1200,76,400,75,200,76,200,76,300,72,300,74,1800,76,400,75,200,76,600,75,200,76,400,69,200,72,1200,76,400,76,200,76,200,67,300,69,300,72,1600,69,200,69,200,72,200,72,400,77,200,69,400,67,200,67,200,72,200,72,400,76,200,67,400,65,200,65,200,69,200,69,400,74,200,65,400,64,200,64,200,67,200,67,400,72,200,64,400,69,200,69,200,72,200,72,400,77,200,69,400,69,200,69,200,72,200,72,400,78,200,69,400,71,200,71,200,72,200,72,200,73,200,73,200,74,200,74,400,79,600,79,800
#array_layers:	.byte 0xC7:460800
.include "levels/array_layers.data"
.include "levels/fundoverde.data"
.include "levels/fazendav1.data"
.include "levels/Loading.data"
.include "sprites/planta1.data"
.include "sprites/planta2.data"
.include "sprites/planta3.data"
.include "sprites/terrarada.data"
.include "sprites/macaco.data"
.include "sprites/fundopersonagem.data"
.include "sprites/personagem.data"	
#Codigo vai comecar na main.
#Funcoes no final
#Padrao for/while/if : Loop_num
#Padrao funcoes FazerAlgo

.text
main:	
	call GenerateGardens
	FimGenerateGardens:
		
	call LoadGame
	FimLoadGame:
	
	call GAME_LOOP
	call FimPrograma		
	
#O game loop vai ser responsavel por administrar:
#efeitos visuais e coisas que mudam na tela
#receber teclas
#Modificacoes chamarao a renderizacao	
GAME_LOOP: 	

	li t6 0
	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,PularKeyDown   	# Se nao ha tecla pressionada entao vai para FIM			
	call KeyDown
	li t6, 1
	PularKeyDown:
	
	# << local para colocar mudancas no cenario
	
	beq  t6,zero,PularRenderizar
	Renderizar:
		la t0, char_pos
		lh a1 , 0(t0)
		lh a2 , 2(t0)
		li a3 , 5
		la a0 macaco
		call LoadImage
	
		la t0, char_pos
		la a0 macaco
		li a4 , 1
		lw a2 , 0(a0)
		lw a3 , 4(a0)
		lh a0 , 0(t0)
		lh a1,  2(t0)
		add a3 ,a3 ,a1
		add a2 ,a2 ,a0
		call Renderizador
		
		la t0, old_char_pos
		lh a1 , 0(t0)
		lh a2 , 2(t0)
		li a3 , 5
		la a0 macaco
		call UnloadImage
		
		la t0, old_char_pos
		la a0 macaco
		li a4 , 0
		lw a2 , 0(a0)
		lw a3 , 4(a0)
		lh a0 , 0(t0)
		lh a1,  2(t0)
		add a3 ,a3 ,a1
		add a2 ,a2 ,a0
		call Renderizador
	PularRenderizar:
	
		call TocarMusica #CHAMA A MUSICA. COLOQUEI AKI PQ FOI O LUGAR Q O DESEMPENHO FICOU MELHOR
		
	j GAME_LOOP

KeyDown:
	
  	lw t2,4(a0)  			# le o valor da tecla tecla
		
	li t0, 'd'
	li t1, 'D'
	beq t2, t0, MoveRight
	beq t2, t1, MoveRight
	
	li t0, 'a'
	li t1, 'A'
	beq t2, t0, MoveLeft
	beq t2, t1, MoveLeft
		
	li t0, 'w'
	li t1, 'W'
	beq t2, t0, MoveUp
	beq t2, t1, MoveUp
	
	li t0, 's'
	li t1, 'S'
	beq t2, t0, MoveDown
	beq t2, t1, MoveDown

	FIM:	ret				# retorna
	
	
	# t1 = x, t2 = y
	MoveRight:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 0(t0)
		
		# bge t0,t1,Label # t0>=t1 ? PC=Label : PC=PC+4 t0 e t1 sem sinal

		# blt t0,t1,Label # t0<t1 ? PC=Label : PC=PC+4 
		
		addi t5, t1, 4
		bge t5, s8, FIM # se o prÃ³ximo passo vai sair do limite, vai ir para RETURN
		
		addi t1, t1, 4 # 32 bits pra direita
		sh t1, 0(t0)
		ret
		
	MoveLeft:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 0(t0)
		
		addi t5, t1, -4
		blt t5, s7, FIM # se o prÃ³ximo passo vai sair do limite, vai ir para RETURN
		
		addi t1, t1, -4 # 32 bits pra esquerda
		sh t1, 0(t0)
		ret
		
	# s7 = x_bounds_1
	# s8 = x_bounds_2
	# s9 = y_bounds 1
	# s10 = y_bounds 2
	MoveUp:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 2(t0)
		
		addi t5, t1, -4
		blt t5, s10, FIM
		
		addi t1, t1, -4 # 56 bits pra esquerda
		sh t1, 2(t0)
		ret
		
	MoveDown:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 2(t0)
		
		addi t5, t1, 4
		bge t5, s9, FIM
		
		addi t1, t1, 4 # 56 bits pra esquerda
		sh t1, 2(t0)
		ret

LoadGame:
	li a7,30		# coloca o horario atual em s11
	ecall
	add s11 , zero , a0
	
	li a1 , 100
	li a2 , 100
	la a0 Loading
	call LoadScreen
	
	li a0, 3
	call TrocarTela			
	# s7 = x_bounds_1
	# s8 = x_bounds_2
	# s9 = y_bounds 1
	# s10 = y_bounds 2
	
	# O carregamento eh feito aqui para poupar processamento posterior
	##########################
	la t0, char_pos_bounds
	
	lh s7, 0(t0) # x1
	lh s8, 2(t0) # x2
	lh s9, 4(t0) # y1
	lh s10, 6(t0)# y2
	
	##########################
	
	
	li a1 , 0
	li a2 , 0
	li a3 , 3
	la a0 fundoverde
	call LoadImage
	
	li a0 , 0
	li a1 , 0
	li a2 , 320
	li a3 , 240
	li a4 , 1
	call Renderizador

	la t0, char_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 5
	la a0 macaco
	call LoadImage
	
	li a0 , 0
	li a1 , 0
	li a2 , 320
	li a3 , 240
	li a4 , 1
	call Renderizador

	j FimLoadGame

#FUNCOES--->	

TocarMusica:#s11 é o contador
	li a7,30		# coloca o horario atual em a0
	ecall
 	If_TM:
 		blt a0,s11, Fim_If_TM
		la t2,Music_config
 		lw t0, 0(t2)
 		lw t1, 4(t2)
 		lw a2, 8(t2)
 		lw a3, 12(t2)
		If_TM1:
			bne t0,t1, Fim_If_TM1	# contador chegou no final? então  vá para SET_SONG para zerar o contador e as notas (loop infinito)
			sw zero, 4(t2)
			li t1, 0
		Fim_If_TM1:
		la t4, Notas
		li t3,8
		mul t1, t1,t3
		add t4,t4,t1
		lw a0,0(t4)		# le o valor da nota
		lw a1,4(t4)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		
		li a7,30		# coloca o horario atual em a0
		ecall
		
		mv a0,s11
		lw t4, 4(t4)
		add s11,s11,t4

		lw t6, 4(t2)
		addi t6,t6,1
		sw t6,4(t2)		# incrementa o contador de notas
	Fim_If_TM:
	ret

TrocarTela:					#recebe a0	 
	lw t3, selectframeads 			# a0 = 0/1 define a tela, a0 = 2 troca
 	If_TT1: 					 	
 		li t0,2				#recebe o valor da tela atual 
 		bge a0,t0, Else_TT1		#If a0 < 2 troca tela para a0
		sw a0, 0(t3)
		ret
	Else_TT1:				#Se nao, se a tela atual Ã© 1 troca para 0
		lb t1,0(t3)			#se a tela Ã© 0 troca para 1
		li t0, 1
		If_TT2:
			bne t1,t0, Else_TT2
			li t1, 0
			sw t1, 0(t3)
			ret
		Else_TT2:
			li t1, 1
			sw t1, 0(t3)
	ret

LoadScreen:						#Recebe a0, a1, a2;
	lw t0, selectframeads				# a0= endereco imagem
	lb t0,0(t0)					# a1 = x da imagem
 	If_LS: 						# a2 = y da imagem
 		li t1,1					
 		bne t0,t1, Else_LS
 		li t0 0xFF000000
		j Fim_If_LS
	Else_LS:
		li t0 0xFF100000
	Fim_If_LS:
	li t5 , 320
	mul t5 , t5, a2 
	add t0, t5 , t0
	
	lw t1, 0(a0)
	lw t2, 4(a0)
	li t3, 0
	li t4, 0
	addi a0,a0,8
	While_LS:	
		beq t2, t4, EndWhile_LS
		add t0, t0,a1
		While_LS1:
			beq t1, t3, EndWhile_LS1
			lw t5, 0(a0)
			sw t5, 0(t0)
			addi t3,t3,4
			addi a0,a0,4
			addi t0,t0,4
			j While_LS1
		EndWhile_LS1:
		li t5, 320
		sub t5, t5, a1
		sub t5, t5,t1
		add t0, t0, t5
		li t3, 0
		addi t4, t4,1
		j While_LS
	EndWhile_LS:
	ret
	
UnloadImage:						# a0= endereco imagem
	li t0, 76800					# a1 = x da imagem
	mul t0, t0, a3					# a2 = y da imagem
	la t1 , array_layers				# a3 = layer(0,5)
	add t0 , t0, t1
	li t1 , 320
	mul t1,a2,t1
	add t0,t0,t1					
 	lw t2, 0(a0)
	lw t3, 4(a0)
	li t4, 0
	li t5, 0
	li t6 ,0xC7C7C7C7
	While_UI:	
		beq t3, t4, EndWhile_UI
		add t0, t0,a1
		While_UI1:
			beq t2, t5, EndWhile_UI1
			sw t6, 0(t0)
			addi t5,t5,4
			addi t0,t0,4
			j While_UI1
		EndWhile_UI1:
		li t5, 320
		sub t5, t5, a1
		sub t5, t5,t2
		add t0, t0, t5
		li t5, 0
		addi t4, t4,1
		j While_UI
	EndWhile_UI:					
 	ret						

LoadImage:						# a0= endereco imagem
	li t0, 76800					# a1 = x da imagem
	mul t0, t0, a3					# a2 = y da imagem
	la t1 , array_layers				# a3 = layer(0,5)
	add t0 , t0, t1	
	li t1 , 320
	mul t1,a2,t1
	add t0,t0,t1				
 	lw t2, 0(a0)
	lw t3, 4(a0)
	li t4, 0
	li t5, 0
	addi a0,a0,8
	While_LI:	
		beq t3, t4, EndWhile_LI
		add t0, t0,a1
		While_LI1:
			beq t2, t5, EndWhile_LI1
			lw t6, 0(a0)
			sw t6, 0(t0)
			addi t5,t5,4
			addi a0,a0,4
			addi t0,t0,4
			j While_LI1
		EndWhile_LI1:
		li t5, 320
		sub t5, t5, a1
		sub t5, t5, t2
		add t0, t0, t5
		li t5, 0
		addi t4, t4,1
		j While_LI
	EndWhile_LI:
	ret	

Renderizador:
	lw t0, selectframeads	
	lb t0, 0(t0)					#a0 = x0
	xori t0,t0,1					#a1 = y0
	li t1, 0xFF0					#a2 = x1
	add t0 ,t0,t1					#a3 = y1
	slli t0 ,t0, 20					#a4 = atualizar tela ou nao				
	la t6, array_layers				#x1 < x2, y1 < y2
	li t5 , 320					#t0 eh o endereco da tela
	mul t5 , t5, a1					#t1/t2/t3/t4 sao os contadores
	add t0, t5 , t0					#t5 eh usado como valor temporario a todo momento
	add t6, t5,t6					#t6 eh o endereco na memoria
	sub t1,a3,a1					#ESTOU USANDO a7 e a6 COMO TEMP
	sub t2,a2,a0
	li t3, 0
	li t4, 0
	li a6, 0xffffffC7
	While_R:	
		beq t1, t4, EndWhile_R
		add t0, t0,a0
		add t6, t6,a0
		While_R1:
			beq t2, t3, EndWhile_R1
			add a7, t6, zero
			li t5,384000
			add a7, a7,t5
			While_R2:
				lb t5,0(a7)
				bne t5, a6,EndWhile_R2
				li t5 , 268577812
				blt a7,t5,EndWhile_R3
				li t5, 76800
				sub a7, a7,t5
				j While_R2
			EndWhile_R3:
			li t5, 0xc7
			EndWhile_R2:
			sb t5, 0(t0)
			addi t3,t3,1
			addi t0,t0,1
			addi t6,t6,1
			j While_R1
		EndWhile_R1:
		li t5, 320
		sub t5, t5, a2
		add t0, t0, t5
		add t6,t6,t5
		li t3, 0
		addi t4, t4,1
		j While_R
	EndWhile_R:
	beq a4, zero , Fim_R
	lw t0, selectframeads	
	lb t1, 0(t0)			
	xori t1,t1,1
	sb t1,0(t0) 
	Fim_R:ret
	
# a2 = estado_tipo (byte)
GenerateGardens:
	la s0, garden_matriz_x
	la s1, garden_matriz_y
	li s2, 5 # tamanho_x
	li s3, 3 # tamanho_y
	li s11, 1
	
	# depois implementar um algoritmo para mudar os tipos de janela usando a3
	
	li s4, 0 # i = 0
	For_GG_1:
		bgeu s4, s3, Done_GG_1
		li s5, 0 # j = 0
		
		For_GG_2:
			bgeu s5, s2, Done_GG_2
			
			la a0, terrarada # endereco da imagem
					
			slli t0, s5, 1 # t0 = j * 2
			add t1, s0, t0 # move o ponteiro para a direita t0 vezes
			lh a1, 0(t1) # x da imagem
			
			slli t0, s4, 1 # t0 = i * 2
			add t1, s1, t0 # move o ponteiro da matriz_y agora
			lh a2, 0(t1) # y da imagem
			
			li a3, 4 # layer 4
			
			call LoadImage
			
			addi s5, s5, 1
			j For_GG_2
			
		Done_GG_2:
			addi s4, s4, 1 # incrementa a linha
			j For_GG_1
		
	Done_GG_1:
		call TrocarTela
		li t0, 3
		bgeu s11, t0, SAIR
		addi s11, s11, 1
		j For_GG_1
		
	SAIR: j FimGenerateGardens

FimPrograma:		#Nao recebe nada
	li a7,10      	#Chama o procedimento de finalizar o programa
	ecall		#Nao retorna nada
