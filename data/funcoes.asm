#FUNCOES--->
TocarMusica:#s11 Ã© o contador
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
			bne t0,t1, Fim_If_TM1	# contador chegou no final? entÃ£o  vÃ¡ para SET_SONG para zerar o contador e as notas (loop infinito)
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
	Else_TT1:				#Se nao, se a tela atual ÃƒÂ© 1 troca para 0
		lb t1,0(t3)			#se a tela ÃƒÂ© 0 troca para 1
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
	#array layers Ã© a memoria das camadas
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

Renderizador2:
	#le o frame atual e pega o outro para modificar
	#array layers Ã© a memoria das camadas
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
		# t2 era minha posição
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
	li a3 , 5
	la a0 macaco
	call UnloadImage
	
	la t0, char_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 5
	la a0 ,macaco
	call LoadImage

	la t0, var
	la a0 fazendav2
	li a1 , 0
	li a2 , 0
	li a3 , 3
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
	
	li a7, 32
	li a0, 20
	ecall
	
	j Loop_AS

FimPrograma:		#Nao recebe nada
	li a7,10      	#Chama o procedimento de finalizar o programa
	ecall			#Nao retorna nada
