#FUNCOES--->
TocarMusica:						#s11 eh o contador de tempo
	li a7,30					#coloca o horario atual em a0
	ecall						#função não recebe entrada
 	If_TM:						#apenas toca a proxima nota de Notas
 		blt a0,s11, Fim_If_TM
		la t2,Music_config
 		lw t0, 0(t2)
 		lw t1, 4(t2)
 		lw a2, 8(t2)
 		lw a3, 12(t2)
		If_TM1:
			bne t0,t1, Fim_If_TM1	# contador chegou no final? entÃƒÂ£o  vÃƒÂ¡ para SET_SONG para zerar o contador e as notas (loop infinito)
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
	Else_TT1:				#Se nao, se a tela atual ÃƒÆ’Ã‚Â© 1 troca para 0
		lb t1, 0(t3)			#se a tela for 0 troca para 1 vice-versa
		xori t1,t1,1
		sb t1,0(t3) 
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

# a1 = x da imagem
# a2 = y da imagem
# a3 = layer(0,5)
# a7 vai ser variavel aq
UnloadImage:
	#If_UI1: se y >= 240, return	
	li t0,240	
	bge a2,t0 Fim_UI
	#If_UI2: se X >= 320, return	
	li t0,320	
	bge a1,t0 Fim_UI
	#If_UI3: se y + y(a0) < 0, return		
	lw t0,4(a0)
	add t0,t0,a2
	blt t0,zero Fim_UI	
	#If_UI4: se X + X(a0) < 0, return		
	lw t0,0(a0)
	add t0,t0,a1
	blt t0,zero Fim_UI	
	# Carrega o array_layers e coloca na camada correta															# a0= endereco imagem
	li t0, 76800					
	mul t0, t0, a3					
	la t1 , array_layers				
	add t0 , t0, t1	
	#Carrega variaveis importantes
	lw t2, 0(a0)
	lw t3, 4(a0)
	li t4, 0
	li t5, 0
	li t6 ,0xC7C7C7C7					
	#If_UI5: Se y for negativo a camada inicial vai ser y = 0
	blt a2,zero Else_UI5
	li t1 , 320
	mul t1,a2,t1
	add t0,t0,t1
	Else_UI5:
	#If_UI6: Se y for negativo a0+= y(a0) * -(y)
	bge a2,zero Else_UI6
	add t3,t3,a2
	Else_UI6: 
	#If_UI7: Se 240 - y > y(a0), y(a0) = 240 - y;	
	li t1,240
	sub t1,t1,a2
	bgt t1,t3,Else_UI7
	mv t3,t1
	Else_UI7:
	#If_UI8: Se x for negativo x(a0) += a1
	bge a1,zero Else_UI8
	add t2,t2,a1
	Else_UI8:
	#############################################
	While_UI:	
		beq t3, t4, EndWhile_UI
		#If_UI9: Se x < 0:
		bge a1,zero Else_UI9
		sub a0,a0,a1
		j Fim_If_UI9
		Else_UI9:
		add t0, t0,a1 
		Fim_If_UI9:
		add t1, zero,a1
		While_UI1:
			beq t2, t5, EndWhile_UI1
			li a7, 320
			bge t1,a7 Pular_UI
			sw t6, 0(t0)
			Pular_UI:
			addi t0,t0,4
			addi t1,t1,4
			addi t5,t5,4
			j While_UI1
		EndWhile_UI1:
		li t5, 320
		sub t5, t5, a1
		bge a1,zero Else_UI10
		add t5,t5,a1
		Else_UI10:
		sub t5, t5,t2
		add t0, t0, t5
		li t5, 0
		addi t4, t4,1
		j While_UI
	EndWhile_UI:					
 	Fim_UI:ret						
# a0= endereco imagem
# a1 = x da imagem
# a2 = y da imagem
# a3 = layer(0,5)
# a7 vai ser uma variavel
LoadImage:	
	#If_LI1: se y >= 240, return	
	li t0,240	
	bge a2,t0 Fim_LI
	#If_LI2: se X >= 320, return	
	li t0,320	
	bge a1,t0 Fim_LI
	#If_LI3: se y + y(a0) < 0, return		
	lw t0,4(a0)
	add t0,t0,a2
	blt t0,zero Fim_LI	
	#If_LI4: se X + X(a0) < 0, return		
	lw t0,0(a0)
	add t0,t0,a1
	blt t0,zero Fim_LI	
	# Carrega o array_layers e coloca na camada correta															# a0= endereco imagem
	li t0, 76800					
	mul t0, t0, a3					
	la t1 , array_layers				
	add t0 , t0, t1	
	#Carrega variaveis importantes
	lw t2, 0(a0)
	lw t3, 4(a0)	
	li t4, 0
	li t5, 0											
	addi a0,a0,8
	#If_LI5: Se y for negativo a camada inicial vai ser y = 0
	blt a2,zero Else_LI5
	li t1 , 320
	mul t1,a2,t1
	add t0,t0,t1
	Else_LI5:
	#If_LI6: Se y for negativo a0+= y(a0) * -(y)
	bge a2,zero Else_LI6
	mul t1,a2,t2
	sub a0,a0,t1
	add t3,t3,a2
	Else_LI6: 
	#If_LI7: Se 240 - y > y(a0), y(a0) = 240 - y;	
	li t1,240
	sub t1,t1,a2
	bgt t1,t3,Else_LI7
	mv t3,t1
	Else_LI7:
	#If_LI8: Se x for negativo x(a0) += a1
	bge a1,zero Else_LI8
	add t2,t2,a1
	Else_LI8: 
	#############################################		
	While_LI:	
		beq t3, t4, EndWhile_LI
		#If_LI9: Se x < 0:
		bge a1,zero Else_LI9
		sub a0,a0,a1
		j Fim_If_LI9
		Else_LI9:
		add t0, t0,a1 
		Fim_If_LI9:
		add t1, zero,a1
		While_LI1:
			beq t2, t5, EndWhile_LI1
			li a7, 320
			bge t1,a7 Pular_LI
			lw t6, 0(a0)
			sw t6, 0(t0)
			Pular_LI:
			addi t0,t0,4
			addi t1,t1,4
			addi t5,t5,4
			addi a0,a0,4
			j While_LI1
		EndWhile_LI1:
		li t5, 320
		sub t5, t5, a1
		bge a1,zero Else_LI10
		add t5,t5,a1
		Else_LI10:
		sub t5, t5, t2
		add t0, t0, t5
		li t5, 0
		addi t4, t4,1
		j While_LI
	EndWhile_LI:
	Fim_LI:ret	

LoadAnimation:						# a0= endereco imagem
	li t0, 76800					# a1 = x da imagem
	mul t0, t0, a3					# a2 = y da imagem
	la t1 , array_layers				# a3 = layer(0,5)
	add t0 , t0, t1					# a4 = jump x
	li t1 , 320
	mul t1,a2,t1
	add t0,t0,t1
	mv t1,a0				
 	li t2, 320
	li t3, 240
	li t4, 0
	li t5, 0
	addi a0,a0,8
	While_LA:	
		beq t3, t4, EndWhile_LA
		add t0, t0,a1
		add a0, a0,a4
		While_LA1:
			beq t2, t5, EndWhile_LA1
			lw t6, 0(a0)
			sw t6, 0(t0)
			addi t5,t5,4
			addi a0,a0,4
			addi t0,t0,4
			j While_LA1
		EndWhile_LA1:
		li t5, 320
		sub t5, t5, a1
		sub t5, t5, t2
		add t0, t0, t5
		
		lw t5,0(t1)
		sub t5,t5,t2
		add a0,a0,t5
		sub a0,a0,a4
		li t5, 0
		addi t4, t4,1
		j While_LA
	EndWhile_LA:
	ret


Renderizador:
	#le o frame atual e pega o outro para modificar
	#array layers ÃƒÂ© a memoria das camadas
	#
	lw t0, selectframeads				#a4 = atualizar tela ou nao
	lb t0, 0(t0)					#x1 < x2, y1 < y2
	xori t0,t0,1					#t0 eh o endereco da tela
	li t1, 0xFF0					#t1/t2/t3/t4 sao os contadores
	add t0 ,t0,t1					#t5 eh usado como valor temporario a todo momento
	slli t0 ,t0, 20					#t6 eh o endereco na memoria
	################				#ESTOU USANDO a7 e a6 COMO TEMP			
	la t6, array_layers				
	li t1,320
	li t2,240									
	li t3, 0
	li t4, 0
	li a6, 0xffffffC7
	While_R:	
		beq t1, t4, EndWhile_R
		While_R1:
			beq t2, t3, EndWhile_R1
			li t5,384000
			add a7, t6, t5
			While_R2:
				lb t5,0(a7)
				bne t5, a6,EndWhile_R2
				la t5 , array_layers 
				li a5, 76800
				add t5, t5,a5
				blt a7,t5,EndWhile_R3
				li t5, 76800
				sub a7, a7,t5
				j While_R2
			EndWhile_R3:
			li t5, 0
			EndWhile_R2:
			sb t5, 0(t0)
			addi t3,t3,1
			addi t0,t0,1
			addi t6,t6,1
			j While_R1
		EndWhile_R1:
		li t3, 0
		addi t4, t4,1
		j While_R
	EndWhile_R:
	lw t0, selectframeads	
	lb t1, 0(t0)			
	xori t1,t1,1
	sb t1,0(t0) 
	ret
# deixei aqui o renderizador que le baseado em a0, a1, a2 e a3, se for usar teste, pois nao conferi codigo
Renderizador2:
	#le o frame atual e pega o outro para modificar
	#array layers ÃƒÂ© a memoria das camadas
	#
	lw t0, selectframeads	
	lb t0, 0(t0)					#a0 = x0
	xori t0,t0,1					#a1 = y0
	li t1, 0xFF0					#a2 = x1
	add t0 ,t0,t1					#a3 = y1
	slli t0 ,t0, 20
	################				#a4 = atualizar tela ou nao				
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
	While_2R:	
		beq t1, t4, EndWhile_2R
		add t0, t0,a0
		add t6, t6,a0
		While_2R1:
			beq t2, t3, EndWhile_2R1
			add a7, t6, zero
			li t5,384000
			add a7, a7,t5
			While_2R2:
				lb t5,0(a7)
				bne t5, a6,EndWhile_2R2
				la t5 , array_layers 
				blt a7,t5,EndWhile_2R3
				li t5, 76800
				sub a7, a7,t5
				j While_2R2
			EndWhile_2R3:
			li t5, 0
			EndWhile_2R2:
			sb t5, 0(t0)
			addi t3,t3,1
			addi t0,t0,1
			addi t6,t6,1
			j While_2R1
		EndWhile_2R1:
		li t5, 320
		sub t5, t5, a2
		add t0, t0, t5
		add t6,t6,t5
		li t3, 0
		addi t4, t4,1
		j While_2R
	EndWhile_2R:
	beq a4, zero , Fim_2R
	lw t0, selectframeads	
	lb t1, 0(t0)			
	xori t1,t1,1
	sb t1,0(t0) 
	Fim_2R:ret

WaterGarden:
		# t2 era minha posiÃ§Ã£o
		mv a0,t2
		# essa parte vai salvar o estado do jardim atual
		la t0, garden_state
		add t1, t0, a0 			# move o ponteiro para o indice correto
		lb a1, 0(t1)
		addi a1, a1, 1
		sb a1, 0(t1)			# salva o novo valor
		
		li t0,5
		rem t5,a0,t0
		divu t6,a0,t0
		# t5 = x_garden_state
		# t6 = y_garden_state

		# modificando sprite da plantacao
		li t0, 36
		li t1, 28
		li t2, 92
		# 88 + (36 * x)
		
		mul t4, t5, t0
		addi t5, t4, 88

		# 92 + (28 * y)
		mul t4, t6, t1
		add t6, t2, t4

		# t5 = garden_x
		# t6 = garden_y

		li t0, 1
		li t1, 2
		li t3, 3

		beq a1, t0, PLANTA1
		beq a1, t1, PLANTA2
		beq a1, t3, PLANTA3

		PLANTA1:
			la a0, planta1
			j PLANTAR

		PLANTA2:
			la a0, planta2
			j PLANTAR

		PLANTA3:
			la a0, planta3
			j PLANTAR

		VOLTAR:
			ret

		PLANTAR:
			mv a1, t5 # x da imagem
			mv a2, t6 # y da imagem
			li a3, 4 # layer 4
			call LoadImage

		j GAME_LOOP	

AnimationScreen:
	Loop_AS:
	
	call TocarMusica
	
	la t0, old_char_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 4
	la a0 macaco
	call UnloadImage
	
	la t0, char_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 4
	la a0 ,macaco
	call LoadImage

	la t0, var
	la a0 fazendav2
	li a1 , 0
	li a2 , 0
	li a3 , 2
	lw a4,0(t0)
	call LoadAnimation
	
	call Renderizador
	
	la t0, var
	lw t2, 0(t0)
	li t1, 160
	beq t1,t2,FimAnimacaoUm
	addi t2,t2,4
	sw t2,0(t0)
	
	la t0, char_pos
	la t1, old_char_pos
	lh t2 , 0(t0)
	sh t2 , 0(t1)
	addi t2,t2,-4
	sh t2 , 0(t0)

	#
	la t0, indio_pos
	la t1, old_indio_pos
	li t3, 1
	sh t3, 4(t0)
	lh t2, 0(t0)
	sh t2, 0(t1)
	addi t2, t2, -4
	sh t2, 0(t0)
	
	#li t3, 160
	#sh t3, 0(t0)
	#
	
	li a7, 32
	li a0, 20
	ecall
	
	j Loop_AS

Inimigo:
	
	#li a0, 200
	#li a7, 32
	#ecall

	la t0, indio_pos
	la t1, old_indio_pos
	lh a1, 0(t0)
	sh a1, 0(t1)
	sh zero, 6(t0)
	li t3, 232
	li t4, 88
	li t5, -1
	lh t6, 4(t0)
	
	beq t6, t5, Esq
	
Dir:	beq a1, t3, Reset
	addi a1, a1, 4
	sh a1, 0(t0)
	sh t6, 4(t0)
	j Back1
	
Esq:	beq a1, t4, Reset
	addi a1, a1, -4
	sh a1, 0(t0)
	sh t6, 4(t0)
	j Back1
	
Reset:
	mul t6, t6, t5
	sh t6, 4(t0)
	j Back1
	

FimPrograma:			#Nao recebe nada
	li a7,10      		#Chama o procedimento de finalizar o programa
	ecall			#Nao retorna nada
