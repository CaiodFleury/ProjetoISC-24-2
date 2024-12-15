.data
selectframeads:	.word 0xFF200604
char_pos:	.half 80, 176
old_char_pos:	.half 80, 176

char_pos_bounds:.half 80, 240, 232, 64

.include "levels/map_placeholder.s"
.include "sprites/fundopersonagem.data"
.include "sprites/personagem.data"	

#Codigo vai comecar na main.
#Funcoes no final
#Padrao for/while/if : Loop_num
#Padrao funcoes FazerAlgo
#Codigo vai comecar na main.
#Funcoes no final
#Padrao for/while/if : Loop_num
#Padrao funcoes FazerAlgo

.text
main:
	# s7 = x_bounds_1
	# s8 = x_bounds_2
	# s9 = y_bounds 1
	# s10 = y_bounds 2
	
	# O carregamento é feito aqui para poupar processamento posterior
	##########################
	la t0, char_pos_bounds
	
	lh s7, 0(t0) # x1
	lh s8, 2(t0) # x2
	lh s9, 4(t0) # y1
	lh s10, 6(t0)# y2
	
	##########################
	
	li a0, 0
	call TrocarTela	

	li a2 , 0
	li a1 , 0
	la a0 map_placeholder
	call LoadScreen 


	li a0, 3
	call TrocarTela	

	li a2 , 0
	li a1 , 0
	la a0 map_placeholder
	call LoadScreen 
	
	call GAME_LOOP		
	
GAME_LOOP:
	call KeyDown
	xori s0, s0,1
	
	la t0, char_pos
	
	la a0, personagem
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	call LoadScreen
	
	lw t0, selectframeads
	sw s0,0(t0)
	
	la t0, old_char_pos
	
	la a0, fundopersonagem
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	xori a3, a3,1
	call LoadScreen
	
	j GAME_LOOP

KeyDown:
	li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla

			
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
		
		addi t5, t1, 32
		bge t5, s8, FIM # se o próximo passo vai sair do limite, vai ir para RETURN
		
		addi t1, t1, 32 # 32 bits pra direita
		sh t1, 0(t0)
		ret
		
	MoveLeft:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 0(t0)
		
		addi t5, t1, -32
		blt t5, s7, FIM # se o próximo passo vai sair do limite, vai ir para RETURN
		
		addi t1, t1, -32 # 32 bits pra esquerda
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
		
		addi t5, t1, -56
		blt t5, s10, FIM
		
		addi t1, t1, -56 # 56 bits pra esquerda
		sh t1, 2(t0)
		ret
		
	MoveDown:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 2(t0)
		
		addi t5, t1, 56
		bge t5, s9, FIM
		
		addi t1, t1, 56 # 56 bits pra esquerda
		sh t1, 2(t0)
		ret

#FUNÇÕES--->	

TrocarTela:					#recebe a0	 
	lw t3, selectframeads 			# a0 = 0/1 define a tela, a0 = 2 troca
 	If_TT1: 					 	
 		li t0,2				#recebe o valor da tela atual 
 		bge a0,t0, Else_TT1		#If a0 < 2 troca tela para a0
		sw a0, 0(t3)
		ret
	Else_TT1:				#Se não, se a tela atual é 1 troca para 0
		lb t1,0(t3)			#se a tela é 0 troca para 1
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
	lw t0, selectframeads				# a0= endereço imagem
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

FimPrograma:		#Não recebe nada
	li a7,10      	#Chama o procedimento de finalizar o programa
	ecall		#Não retorna nada
	
	
	
	
	
	
	
	
	
	
	
	
	
	