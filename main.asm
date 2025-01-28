.data
.include "data/imagens.asm"
.include "data/config.asm"
.text
#Codigo vai comecar na main.
#Funcoes no final
#Padrao for/while/if : Loop_num
#Padrao funcoes FazerAlgo
#UNICA VARIAVEL GLOBAL Eh S11 q eh o tempo atual
main:	
	
	call StartScreen
	FimStartScreen:
	
	#colocar animacao de introducao aqui
			
	call LoadGame
	FimGame:
	
	call FimPrograma
	
#Administrador maximo do jogo
LoadGame:

	li a7,30		# coloca o horario atual em s11
	ecall
	add s11 , zero , a0
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
	la t0, char_pos
	li t1,100
	sh t1,0(t0)
	li t1,120
	sh t1,2(t0)	
	la t0, indio_pos
	li t1,300
	sh t1,0(t0)
	li t1,48
	sh t1,2(t0)
	sw zero,4(t0)
	la t0, game_moment
	sb zero,0(t0)
	#Primeira parte do nivel
	li a1 , 0
	li a2 , 0
	li a3 , 2
	la a0 fazendav1
	call LoadImage
	
	li a1 , 0
	li a2 , 0
	li a3 , 0
	la a0 colisao1
	call LoadImage
	
	call GAME_LOOP
	#Segunda parte do nivel
	SegundaParte:
	call AnimationScreen
	FimAnimacaoUm:
	
	li a1 , 0
	li a2 , 0
	li a3 , 0
	la a0 colisao2
	call LoadImage
	
	li a1 , 20
	li a2 , 0
	li a3 , 6
	la a0 placaHUD
	call LoadImage 
	
	li a1 , 270
	li a2 , 13
	li a3 , 6
	la a0 placaHUD2
	call LoadImage 
	
	li a1 , 20
	li a2 , 0
	li a3 , 6
	la a0 placaHUD
	call LoadImage 
	
	li a1 , 20
	li a2 , 52
	li a3 , 6
	la a0 gorilavida
	call LoadImage 
	
	li a1 , 39
	li a2 , 52
	li a3 , 6
	la a0 gorilavida
	call LoadImage 
	
	li a1 , 58
	li a2 , 52
	li a3 , 6
	la a0 gorilavida
	call LoadImage 
	
	la t0, game_moment
	li t1,1
	sb t1,0(t0)
	
	call GAME_LOOP
	#terceira parte do nivel
	TerceiraParte:
	
	call EndDayScreen
	FimEndDayScreen:
	
	la t0, level
	lb t1,0(t0)
	addi t1,t1,1
	sb t1,0(t0)
	
	j LoadGame
	
#O game loop vai ser responsavel por administrar:
#efeitos visuais e coisas que mudam na tela
#receber teclas
#Modificacoes chamarao a renderizacao	
#Variaveis S vao ser utilizadas para colocar os tempos das coisas
#S0  - Tempo atual
#S8  - Mosquito
#S9  - Delay vida
#S10 - Player
#S11 - Musica
GAME_LOOP: 	
	
	li a7,30			# coloca o horario atual em s11
	ecall
	mv s0, a0
	
	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,PularKeyDown   	# Se nao ha tecla pressionada entao vai para FIM			
	call KeyDown
	PularKeyDown:
	
	addi t0, s10, 500		#Reseta a anima��o do personagem para a inicial
	blt s0, t0, NaoResetar
	li t1, 3
	la t2, sprite_macaco
	lb t4,0(t2)
	sb t1,0(t2)
	ble t4,t1, NaoResetar
	li t1,7
	sb t1,0(t2) 
	NaoResetar:
	
	#INICIO RENDERIZACAO MACACO
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
	la t0,sprite_macaco
	lb t0,0(t0)
	li t1,548
	mul t0,t1,t0
	la a0 , macaco1
	add a0,t0,a0
	call LoadImage
	#FIM RENDERIZACAO MACACO
	#INICIO TESTE COLISAO
	la t0, char_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	la a0,macaco1
	call EstaColidindo
	
	beq a3,zero, Pular_DecrescimoDeVida
	bltu s0, s9, Pular_DecrescimoDeVida
	addi s9, s0, 500
	la t0, vidas
	lb t1, 0(t0)
	addi t1,t1,-1
	sb t1,0(t0)
	beq t1,zero,FimGame
	li t3,2
	li t2,1
	beq t1,t3,TirarVida3
	beq t1,t2,TirarVida2
	j Pular_DecrescimoDeVida 
	TirarVida3:
		li a1 , 58
		li a2 , 52
		li a3 , 6
		la a0 gorilavida
		call UnloadImage
		j Pular_DecrescimoDeVida
	TirarVida2:
		li a1 , 39
		li a2 , 52
		li a3 , 6
		la a0 gorilavida
		call UnloadImage 
	Pular_DecrescimoDeVida:
	#FIM TESTE COLISAO
	
	#GAMEMOMENT == 1
	la t0, game_moment
	lb t0,0(t0)	
	beq t0, zero, PularGameMoment1
		#Mosca 1 adiministrador
		bltu s0, s8, Fim_Mosca1
		addi s8, s0, 20
		la t0, mosq1_pos
		lh a1 , 0(t0)
		lh a2 , 2(t0)
		li a3 , 1
		la a0 mosquito
		call UnloadImage
		
		la t0, mosq1_pos
		lh a1 , 0(t0)
		lh a2 , 2(t0)
		li a3 , 6
		la a0 mosquito
		li t2,340
		beq a1,t2,PuLLLLAraaa
		addi t1,a1,4
		sh t1,0(t0)
		j PULLAR
		PuLLLLAraaa:
		sh zero,0(t0)
		li a7, 40
		mv a1, s0
		ecall
		li t1,60
		rem a0,a0,t1
		addi a0,a0,100
		sh a0,2(t0)
		PULLAR:
		call UnloadImage
		
		la t0, mosq1_pos
		lh a1 , 0(t0)
		lh a2 , 2(t0)
		li a3 , 1
		la a0 mosquito
		call LoadImage
		
		la t0, mosq1_pos
		lh a1 , 0(t0)
		lh a2 , 2(t0)
		li a3 , 6
		la a0 mosquito
		call LoadImage
		Fim_Mosca1:
	PularGameMoment1:
	#FIMGAMEMOMENT == 1
	
	la t0,bananatotal
	lb t0,0(t0)
	li t1,10
	beq t1,t0,TerceiraParte	
	
	call TocarMusica
	
	call Renderizador
	
	call GrowGarden
							
	j GAME_LOOP
	
#######################################
#############FIM GAME_LOOP#############
#######################################

KeyDown:				#Recebe:
					# a0 - o endereco de controle do KDMMIO
  	lw t2,4(a0)  			# a1 - recebe ponto na tela que deve ser analizadp
		
	#Variaveis para atingir o ponto atual
	la t6,array_layers
	la t5, char_pos
	lh t3, 0(t5)
	lh t4, 2(t5)
	#operações para chegar no ponto certo
	add t6,t6,t3
	li t3,320
	mul t4,t4,t3
	add t6,t4,t6
	li t4,8640
	add t6,t6,t4
	# t6 recebe o valor do pixel na tela desejado q é o ponto esquerdo inferior
	
	li t0, 'e'
	beq t2,t0, SpaceInteraction	
	
	#Se delay esta acontecendo ele nao pode se mover
	bltu s0,s10, FIM
	addi s10,s0,40
	#Troca a posição antiga com a atual e carrega t5 com char_pos
	la t5, char_pos
	la t4, old_char_pos
	lw t3, 0(t5)
	sw t3, 0(t4)
	
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
	
	li t0, 'n'
	li t1, 'N'
	beq t2, t0, MoveDownLeft
	beq t2, t1, MoveDownLeft
	
	li t0, 'j'
	li t1, 'J'
	beq t2, t0, MoveUpLeft
	beq t2, t1, MoveUpLeft
		
	li t0, 'm'
	li t1, 'M'
	beq t2, t0, MoveDownRight
	beq t2, t1, MoveDownRight
	
	li t0, 'k'
	li t1, 'K'
	beq t2, t0, MoveUpRight
	beq t2, t1, MoveUpRight

	add s10,s0,zero

	FIM:	ret				# retorna
	
	SpaceInteraction:
		lb t2,0(t6)
		li t3, 20
		bltu t2,t3,WaterGarden
		ret
	
	MoveRight:
		
		addi t6,t6,4
		lb t2,0(t6)
		li t3,-110
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		
		li t3,63
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		
		lh t2, 0(t5)
		addi t2, t2,4
		sh t2, 0(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		blt t1, t2, FIM
		sb zero,0(t0)
		ret
		
	MoveLeft:
		addi t6,t6,-4
		
		lb t2,0(t6)
		li t6,-110
		beq t2,t6,FIM
		
		lh t1,0(t5)
		addi t1, t1, -4
		sh t1, 0(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		bge t1, t2, Pular_PKE
		sb t2,0(t0)
		ret
		Pular_PKE:
		li t3,7
		blt t1,t3, FIM
		sb t2,0(t0)
		ret
		
		
	MoveUp:
		addi t6,t6,-1280
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lh t1, 2(t5)
		addi t1, t1, -4 
		sh t1, 2(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,8
		sb t1,0(t0)
		bgt t1, t2, Pular_PKU
		sb t2,0(t0)
		ret
		Pular_PKU:
		li t3,11
		blt t1,t3, FIM
		sb t2,0(t0)
		
		ret
		
	MoveDown:

		addi t6,t6,1280
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lh t1, 2(t5)
		addi t1, t1, 4 
		sh t1, 2(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,11
		sb t1,0(t0)
		bgt t1, t2, Pular_PKD
		sb t2,0(t0)
		ret
		Pular_PKD:
		li t3,14
		blt t1,t3, FIM
		sb t2,0(t0)
		
		ret
		
	MoveDownRight:
		addi t6,t6,1284
		lb t2,0(t6)
		li t3,-110
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		
		li t3,63
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		
		
		addi s10,s10,20
		
		lh t2, 0(t5)
		addi t2, t2,4
		sh t2, 0(t5)
		lh t2, 2(t5)
		addi t2, t2,4
		sh t2, 2(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		blt t1, t2, FIM
		sb zero,0(t0)
		
		ret
		
	MoveUpRight:
		addi t6,t6,-1276
		lb t2,0(t6)
		li t3,-110
		
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		li t3,63
		
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		
		addi s10,s10,20
		
		lh t2, 0(t5)
		addi t2, t2,4
		sh t2, 0(t5)
		lh t2, 2(t5)
		addi t2, t2,-4
		sh t2, 2(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		blt t1, t2, FIM
		sb zero,0(t0)
		
		ret
	
	MoveUpLeft:
		addi t6,t6,-1284
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		addi s10,s10,20
		
		lh t1, 2(t5)
		addi t1, t1, -4 
		sh t1, 2(t5)
		lh t1, 0(t5)
		addi t1, t1, -4 
		sh t1, 0(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		bge t1, t2, Pular_PKEU
		sb t2,0(t0)
		ret
		Pular_PKEU:
		li t3,7
		blt t1,t3, FIM
		sb t2,0(t0)
		ret
		
		ret
	
	MoveDownLeft:
		addi t6,t6,1276
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM
			
		addi s10,s10,20

		lh t1, 2(t5)
		addi t1, t1, 4 
		sh t1, 2(t5)
		lh t1, 0(t5)
		addi t1, t1, -4 
		sh t1, 0(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		bge t1, t2, Pular_PKED
		sb t2,0(t0)
		ret
		Pular_PKED:
		li t3,7
		blt t1,t3, FIM
		sb t2,0(t0)
		ret
		
		ret
.include "data/funcoes.asm"
	
	la t0, indio_pos
	lh t1, 4(t0)
	beq t1, zero, Back2
	
	la t0, indio_pos
	lh t1, 6(t0)
	li t2, 20
	addi t1, t1, 1
	sh t1, 6(t0)
	bne t1, t2, Back1
	
	call Inimigo
	
Back1:	#
	
	la t0, old_indio_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 4
	la a0 inimigo
	call UnloadImage
	
	la t0, indio_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 4
	la a0 , inimigo
	call LoadImage
	
	#
Back2:
	la t0, indio_pos
	lh t1, 4(t0)
	bne t1, zero, Skip
	la t0, indio_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 4
	la a0 , inimigo
	call LoadImage
	#
	
Skip:
	
	la t0,bananatotal
	lb t0,0(t0)
	li t1,10
	beq t1,t0,TerceiraParte
