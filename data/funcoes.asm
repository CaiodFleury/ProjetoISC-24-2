#FUNCOES--->

#tela de inicio
StartScreen:
	li a1 , 0
	li a2 , 0
	la a0 ,startscreen
	call LoadScreen
	
	li a0, 2
	call TrocarTela	
	
	Esperar_Leitura_SS:
	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,Esperar_Leitura_SS  # Se nao ha tecla pressionada entao vai para FIM			
	
	j FimStartScreen

#tela de endday
EndDayScreen:

	li a1 , 0
	li a2 , 0
	li a3 , 9
	la a0 ,macacofundofinal
	call LoadImage

	li a1 , 50
	li a2 , 20
	li a3 , 10
	la a0 ,ContagemDpontos
	call LoadImage
	
	la a0, level
	lb a0,0(a0)
	li a1, 164
	li a2, 25
	call PrintNumber
	
	li a0, 0
	li a1, 205
	li a2, 51
	call PrintNumber
	
	li a0, 0
	li a1, 170
	li a2, 74
	call PrintNumber
	
	li a0, 0
	li a1, 165
	li a2, 134
	call PrintNumber
	
	call Renderizador
	li s10, 0 # <- contador
	la s11, bananatotal
	lb s11,0(s11)
	addi s11,s11,1
	ForEndScreen1:
		beq s11,s10,Fim_ForEndScreen1
		li t0,20
		mul a0, t0,s10
		li a1, 205
		li a2, 51
		call PrintNumber
		addi s10,s10,1
		li a0,40
		li a7, 32
		ecall
		call Renderizador
		j ForEndScreen1
	Fim_ForEndScreen1:
	la t0, pontostotais
	la t2, bananatotal
	lw t1,0(t0)
	lb t3,0(t2)
	add t1,t1,t3
	sw t1,0(t0)
	
	li a0,200
	li a7, 32
	ecall
	
	li s10, 0 # <- contador
	mv s11, t1
	addi s11,s11,1
	ForEndScreen2:
		beq s11,s10,Fim_ForEndScreen2
		li t0,20
		mul a0, t0,s10
		li a1, 165
		li a2, 134
		call PrintNumber
		addi s10,s10,1
		li a0,40
		li a7, 32
		ecall
		call Renderizador
		j ForEndScreen2
	Fim_ForEndScreen2:
	
	call Renderizador
	li a0,4000
	li a7, 32
	ecall

	li a0,0xFF200000
	sw zero,0(a0)
	

	Esperar_Leitura_EDS:
	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,Esperar_Leitura_EDS # Se nao ha tecla pressionada entao vai para FIM			
	
	li a1 , 0
	li a2 , 0
	li a3 , 9
	la a0 ,macacofundofinal
	call UnloadImage
	
	li a1 , 0
	li a2 , 0
	li a3 , 10
	la a0 ,macacofundofinal
	call UnloadImage
	
	j FimEndDayScreen

#tela de pause
PauseScreen:
	li a1 , 60
	li a2 , 100
	la a0 , PauseText
	li a3 , 9
	call LoadImage
	call Renderizador
	Esperar_Leitura_PS:
	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,Esperar_Leitura_PS  # Se nao ha tecla pressionada entao vai para FIM			
	
	li a1 , 60
	li a2 , 100
	la a0 , PauseText
	li a3 , 9
	call UnloadImage
	
	li a7,30			# coloca o horario atual em s11
	ecall
	sub t0,a0,s0
	add s6,s6,t0
	add s7,s7,t0
	add s8,s8,t0
	add s9,s9,t0
	add s10,s10,t0
	add s4, s4, t0
	add s5, s5, t0
	add s11,s11,t0
	
	li t1,15
	li t2,0
	li t3,4
	For_PauseS:
	beq t2,t1,FimChangeTimePauseScreen
	mul t4,t3,t2
	addi t2,t2,1
	la t5, garden_time
	add t5,t5,t4
	lw t6, 0(t5)
	li t4,-1
	beq t6,t4,For_PauseS 
	add t6,t6,t0
	sw t6, 0(t5)
	j For_PauseS
	FimChangeTimePauseScreen:
	add s0,a0,zero
	
	j GAME_LOOP

BlackScreen:
	li a4, 0
	For_BS:
	li t0, 320
	beq a4,t0,FimBlackScreen
	la a0,TelaPreta
	mv a1,a4
	li a2,0
	li a3,10
	addi a4,a4,4
	call LoadImage
	call Renderizador
	
	li a7,32
	li a0,10
	ecall
	j For_BS

TocarMusica:						#s11 eh o contador de tempo
	li a7,30					#coloca o horario atual em a0
	ecall						#função não recebe entrada
 	If_TM:						#apenas toca a proxima nota de Notas
 		bltu a0,s11, Fim_If_TM
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
		
		mv s11,a0
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
			sh t6, 0(t0)
			Pular_UI:
			addi t0,t0,2
			addi t1,t1,2
			addi t5,t5,2
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
			lb t6, 0(a0)
			addi a7, t6, 57
			beq a7, zero, Pular_LI
			sb t6, 0(t0)
			Pular_LI:
			addi t0,t0,1
			addi t1,t1,1
			addi t5,t5,1
			addi a0,a0,1
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
			li t5,768000
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

		li t0,5
		rem t5,a0,t0
		divu t6,a0,t0
		# t5 = x_garden_state
		# t6 = y_garden_state

		# modificando sprite da plantacao
		li t0, 35
		li t1, 27
		li t2, 100
		# 88 + (35 * x)
		
		mul t4, t5, t0
		addi t5, t4, 88

		# 100 + (27 * y)
		mul t4, t6, t1
		add t6, t2, t4

		# t5 = garden_x
		# t6 = garden_y
		li t1, 3
		bne a1,t1 NaoResetarWP
		
		la t0, garden_state
		add t1, t0, a0 			# move o ponteiro para o indice correto
		sb zero, 0(t1)
		
		addi t6,t6,-17
		la a0, planta1
		add a1, t5,zero # x da imagem
		add a2, t6,zero # y da imagem
		li a3, 4 # layer 4
		call UnloadImage
		
		la t0,bananatotal
		lb t1,0(t0)
		addi t1,t1,1
		sb t1,0(t0) # t1 quantidade de bananas
		li t2,10
		div t1,t1,t2
		beq t1,zero PularDezenas
		
		li t0, 138
		mul t2, t1, t0 # pegando o indice do sprite do numero
		la t3, n0
		add a0, t3, t2 # pegando o sprite do numero
		
		li a1, 22
		li a2, 18
		li a3, 6
		call LoadImage

		PularDezenas:
		# incrementar o numero de bananas no placar
		la t0,bananatotal
		lb t1,0(t0)
		
		li t0, 138
		li t3,10
		rem t2,t1,t3
		mul t2, t2, t0 # pegando o indice do sprite do numero
		la t3, n0
		add a0, t3, t2 # pegando o sprite do numero

		li a1, 30
		li a2, 18
		li a3, 6
		call LoadImage

		j GAME_LOOP
		#---
		NaoResetarWP:
		
		la t0, garden_time
		li t1,4
		mul t1,a0,t1
		add t0,t1,t0
		addi a2,s0,8000
		sw a2,0(t0)
		
		la a0,TerraMolhada
		mv a1, t5 # x da imagem
		mv a2, t6 # y da imagem
		li a3, 3 # layer 3
		call LoadImage
		
		j GAME_LOOP

GrowGarden:
		li t0,15
		li t1,0
		li t2,4
		For_GG:
		beq t1,t0,FimGrowGarden
		mul t3,t2,t1
		la t4, garden_time
		add t4,t4,t3
		lw t5, 0(t4)
		bgeu s0, t5, Mudar_Pos_GG
		addi t1,t1,1
		j For_GG
		Mudar_Pos_GG:
		li t0,-1
		sw t0,0(t4)
		mv a0,t1

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
		li t0, 35
		li t1, 27
		li t2, 83
		# 88 + (35 * x)
		
		mul t4, t5, t0
		addi t5, t4, 88

		# 83 + (27 * y)
		mul t4, t6, t1
		add t6, t2, t4

		# t5 = garden_x
		# t6 = garden_y
		addi a6,t6,17
		add a5,t5,zero	
		
		li t0, 1
		li t1, 2
		li t3, 3
		
		beq a1, t0, PLANTAG1
		beq a1, t1, PLANTAG2
		beq a1, t3, PLANTAG3
	
		sb t1,0(t0)
		
		j GAME_LOOP
		
		PLANTAG1:
			la a0, planta1
			j PLANTARG

		PLANTAG2:
			la a0, planta2
			j PLANTARG

		PLANTAG3:
			la a0, planta3
			j PLANTARG

		PLANTARG:
			mv a1, t5 # x da imagem
			mv a2, t6 # y da imagem
			li a3, 4 # layer 3
			call LoadImage
		
			la a0, TerraMolhada
			mv a1, a5 # x da imagem
			mv a2, a6 # y da imagem
			li a3, 3 # layer 3
			call UnloadImage

		j GAME_LOOP


EstaColidindo:					# a0= endereco imagem		
	la t0,array_layers			# a1 = x da imagem
	li t1,76800				# a2 = y da imagem
	add t0,t1,t0				# retorna a3, 1 para est� colidindo e 0 se nao esta
	li t1,320
	mul t1,a2,t1
	add t0,t1,t0
	lw t1, 0(a0)
	lw t2, 4(a0)
	li t3, 0
	li t4, 0
	li t6, 0xC7C7C7C7
	While_EC:	
		beq t2, t4, EndWhile_EC
		add t0, t0,a1
		While_EC1:
			beq t1, t3, EndWhile_EC1
			lw t5, 0(t0)
			beq t5,t6, Pular_EC
			li a3, 1
			ret
			Pular_EC:
			addi t3,t3,4
			addi t0,t0,4
			j While_EC1
		EndWhile_EC1:
		li t5, 320
		sub t5, t5, a1
		sub t5, t5,t1
		add t0, t0, t5
		li t3, 0
		addi t4, t4,1
		j While_EC
	EndWhile_EC:
	li a3,0
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

AnimationScreen:
	Loop_AS:
	
	call TocarMusica

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
	li t1, 132
	beq t1,t2,FimAnimacaoUm
	addi t2,t2,4
	sw t2,0(t0)
	
	la t0, Obj1
	lw t2 , 4(t0)
	addi t2,t2,-4
	sw t2 , 4(t0)

	la t0, Obj2
	lw t2, 4(t0)
	addi t2, t2, -4
	sw t2, 4(t0)
		
	li a7, 32
	li a0, 20
	ecall
	
	call SuperRenderv1
	
	j Loop_AS

ResetarVariaveis:
#Inicializacao de variaveis
	li a1 , 0
	li a2 , 0
	li a3 , 2
	la a0 colisao1
	call UnloadImage
	li a1 , 0
	li a2 , 0
	li a3 , 4
	la a0 colisao1
	call UnloadImage
	li a1 , 0
	li a2 , 0
	li a3 , 7
	la a0 colisao1
	call UnloadImage
	li a1 , 0
	li a2 , 0
	li a3 , 5
	la a0 colisao1
	call UnloadImage
	li a1 , 0
	li a2 , 0
	li a3 , 6
	la a0 colisao1
	call UnloadImage
	li a1 , 0
	li a2 , 0
	li a3 , 3
	la a0 colisao1
	call UnloadImage
	la t0,bananatotal
	sb zero,0(t0)
	la t0,garden_state
	li t1,0
	sw t1,0(t0)
	sw t1,4(t0)
	sw t1,8(t0)
	sw t1,12(t0)
	la t0,garden_time
	li t1,-1
	sw t1,0(t0)
	sw t1,4(t0)
	sw t1,8(t0)
	sw t1,12(t0)
	sw t1,16(t0)
	sw t1,20(t0)
	sw t1,24(t0)
	sw t1,28(t0)
	sw t1,32(t0)
	sw t1,36(t0)
	sw t1,40(t0)
	sw t1,44(t0)
	sw t1,48(t0)
	sw t1,52(t0)
	sw t1,56(t0)
	li t0,0
	la t1,var
	sw t0,0(t1)	
	la t0, mosq1_posy
	li t1,4
	sh t1,0(t0)
	la t0, game_moment
	sb zero,0(t0)
	la t0, relogio_pos
	li t1,-1
	sb t1,0(t0)
	j FimInicializacaodevariveis
	
IniciarObjetos:

	la t0,Obj1
	la t1,macaco
	sw t1,0(t0)
	li t1, 100
	li t2, 120
	li t3, 5
	#li t3, 0
	sw t1,4(t0)
	sw t2,8(t0)
	sw t1,12(t0)
	sw t2,16(t0)
	sw t3,20(t0)
	
	la t0,Obj2
	la t1,inimigo
	sw t1,0(t0)
	li t1, 300
	li t2, 48
	li t3, 4
	sw t1,4(t0)
	sw t2,8(t0)
	sw t1,12(t0)
	sw t2,16(t0)
	sw t3,20(t0)
	
	la t0,Obj3
	la t1,mosquito
	sw t1,0(t0)
	sw t1,24(t0)
	li t1, -20
	li t2, 140
	li t3, 6
	sw t1,4(t0)
	sw t2,8(t0)
	sw t1,12(t0)
	sw t2,16(t0)
	sw t3,20(t0)
	
	la t0,Obj4
	la t1,flecha
	sw t1,24(t0)
	
	la t0,Obj5
	la t1,flecha
	sw t1,24(t0)
	
	la t0,Obj6
	la t1,flecha
	sw t1,24(t0)

	ret
SuperRenderv1:	
	mv a4,ra
	li a6,0
	For_SRv:
		li t0,15
		beq a6,t0,Fim_SuperRenderv1
		li t2,28
		mul t2,t2,a6
		la a5, RenderObjFirst
		add a5,a5,t2
		lw t2, 0(a5)
		addi a6,a6,1
		beq zero, t2, For_SRv
		
		lw a0 , 0(a5)
		lw a1 , 12(a5)
		lw a2 , 16(a5)
		lw a3 , 20(a5)
		call UnloadImage
	
		lw a0 , 0(a5)
		lw a1 , 4(a5)
		lw a2 , 8(a5)
		lw a3 , 20(a5)
		call LoadImage
		
		lw t0, 24(a5)
		beq t0,zero,Fim_loadHitBox
		
		lw a0 , 24(a5)
		lw a1 , 12(a5)
		lw a2 , 16(a5)
		li a3 , 1
		call UnloadImage
	
		lw a0 , 24(a5)
		lw a1 , 4(a5)
		lw a2 , 8(a5)
		li a3 , 1
		call LoadImage
		Fim_loadHitBox:
		
		lw t0 , 4(a5)
		lw t1 , 8(a5)
		sw t0 , 12(a5)
		sw t1 , 16(a5)
		
		j For_SRv
	Fim_SuperRenderv1:
	mv ra,a4
	ret

# a0 = numero
# a1 = x
# a2 = y
# 138 = tamanho do sprite
PrintNumber:
	mv s1, ra
	mv s2, a0 # salvando o numero
	mv a4, a1 # x
	mv a5, a2 # y
	li a6, 0 # contador
	PN_Loop:
		li t0,5
		beq a6, t0, PN_End
		#beq s3, zero, PN_Zero

		li t1,10
		rem t0, s2, t1 # pega o ultimo digito
		div s2, s2, t1 # remove o ultimo digito

		#beq s0, zero, PN_Zero # acabou o digito, vai printar o restante 0

		li t4, 138
		mul t0, t0, t4 # pega o indice do sprite
		la t1, n0 # endereco do sprite
		add a0, t1, t0 # pega o sprite

		# os numeros têm 8 bytes de distancia um do outro
		# a1 - (9 * s2) = x (de tras para frente)
		mv a1,a4
		mv a2,a5
		li t0, 9
		mul t0, t0, a6
		sub a1, a1, t0

		li a3, 10 # camada padrao
		
		call LoadImage

		addi a6, a6, 1

		j PN_Loop

	PN_End:
	mv ra, s1
	ret

# retorna:
#	a0 = sprite
GetGardenType:
	li t0, 1032 # tamanho do sprite
	li a7, 41 # randint
	ecall
	la t2, temp # salvara as informacoes para a colisao
	# a0 = numero aleatorio

	#
	# 0 a 5: sem plantacao
	# 5 a 7: plantacao 1
	# 7 a 9: plantacao 2
	# 10: ambos
	#
	
	li t1, 11
	rem a7, a0, t1 # 0 a 10: tipo da planta
	li t1, 5
	ble a7, t1, NP
	li t1, 7
	ble a7, t1, P1
	li t1, 9
	ble a7, t1, P2
	# la a0, planta3

	P1:
		la a0, cerca_1
		li a7, 0
		sw a7, 0(t2) # salva o tipo da planta
		ret
	
	P2:
		#la a0, cerca_2
		la a0, cerca_2_teste
		li a7, 1
		sw a7, 0(t2)
		ret

	NP:
		li a0, -1
		ret

GenerateFence:
	mv s1, ra
	li a5, 0 # contador y

	FOR_GF:
		li t0, 5
		bge a5, t0, END_GF
		li a4, 0 # contador x

		FOR_GF_2:
			li t0, 9
			bge a4, t0, END_GF_2

			la t0, garden_matriz_x
			la t1, garden_matriz_y

			add t0, t0, a4 # ponteiro x
			add t1, t1, a5 # ponteiro y

			lh a1, 0(t0)
			lh a2, 0(t1)

			call GetGardenType # a0 sprite real
			li t0, -1
			beq a0, t0, PULAR #nao vai ter cerca

			la t0, temp # salvara informacoes para colisao
			sw a1, 4(t0)
			sw a2, 8(t0)
			li a3, 4
			call LoadImage

			la t0, temp
			lw a0, 0(t0) # indice
			lw a1, 4(t0) # x
			lw a2, 8(t0) # y

			li t0, 1
			beq a0, t0, Segundo
			la a0, cerca_1_colisao
			j Continue
			Segundo:
				la a0, cerca_2_colisao
			Continue:
			li a3, 0
			call LoadImage
			PULAR: 
			addi a4, a4, 1
			j FOR_GF_2

		END_GF_2:
			addi a5, a5, 1
			j FOR_GF

	END_GF:
		mv ra, s1
		ret

FimPrograma:			#Nao recebe nada
	li a7,10      		#Chama o procedimento de finalizar o programa
	ecall			#Nao retorna nada
