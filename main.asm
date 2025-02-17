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
	
	li a1, 0
	li a2, 0
	li a0, telagameover
	call LoadScreen
	
	li a0, 2
	call TrocarTela
	
	li a7, 30
	ecall
	mv s0, a0
	mv s4, s0
	addi s4, s4, 2000
	FimAux:
	li a7, 30
	ecall
	mv s0, a0
	bltu s0, s4, FimAux
	
	call main
	#call FimPrograma
	
#Administrador maximo do jogo
LoadGame:
	li a7,30		# coloca o horario atual em s11
	ecall
	add s11 , zero , a0
	call ResetarVariaveis
	FimInicializacaodevariveis:
	call IniciarObjetos
	#Primeira parte do nivel
	li a1 , 0
	li a2 , 0
	li a3 , 2
	la a0 fazendav1
	call LoadImage
	
	#
	li a1, 0
	li a2, 0
	li a3, 3
	la a0, wasd
	call LoadImage
	
	li a1, 174
	li a2, 76
	li a3, 3
	la a0, Seta
	call LoadImage
	
	#li a1, 160
	#li a2, 120
	#li a3, 3
	#la a0, colisaopowerup
	#call LoadImage
	
	#
	
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
	li a3 , 5 # TIVE QUE ABAIXAR A CAMADA PARA OS NUMEROS APARECEREM
	la a0 placaHUD
	call LoadImage 
	
	# quantidade de bananas placa
	li a1, 30
	li a2, 18
	li a3, 6
	la a0, n0
	call LoadImage

	li a1, 40
	li a2, 18
	li a3, 6
	la a0, bar
	call LoadImage

	li a1, 48
	li a2, 18
	li a3, 6
	la a0, n1
	call LoadImage
	
	li a1, 56
	li a2, 18
	la a0, n0
	call LoadImage
	#######
	li a1 , 270
	li a2 , 0
	li a3 , 6
	la a0 Relogio1
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
	
	li a1, 94
	li a2, 144
	li a3, 3
	la a0, E
	call LoadImage
	
	la t0, game_moment
	li t1,1
	sb t1,0(t0)
	
	addi s8, s0, 10000
	addi s4, s0, 30000	#tempo que o powerup vai aparecer
	
	call GAME_LOOP
	#terceira parte do nivel
	TerceiraParte:
	
	call BlackScreen
	FimBlackScreen:
	
	li a1 , 0
	li a2 , 0
	li a3 , 10
	la a0 colisao1
	call UnloadImage
	
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
#S1  - Save Return Adress
#s4  - Tempo PowerUp
#s5  - Tempo Flecha
#s6  - Tempo Jogo
#s7  - Indio
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
	la t0,sprite_macaco
	lb t0,0(t0)
	li t1,548
	mul t0,t1,t0
	la a0 , macaco1
	add a0,t0,a0
	la t2, Obj1
	sw a0,0(t2)
	#FIM RENDERIZACAO MACACO
	#INICIO TESTE COLISAO
	la t0, Obj1
	lw a1 , 4(t0)
	lw a2 , 8(t0)
	la a0,macaco
	call EstaColidindo
	
	li t0, 2
	beq a3, t0, PowerDespawn
	beq a3,zero, Pular_DecrescimoDeVida
	bltu s0, s9, Pular_DecrescimoDeVida
	addi s9, s0, 1400
CheatVida:
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
	#
	call PowerUp
SkipPower:
	#
		#Mosca 1 adiministrador
		bltu s0, s8, Fim_Mosca1
		addi s8, s0, 60
		
		la t0, Obj3
		la t1, mosq1_posy
		lh t2 , 4(t0)
		li t3,340
		beq t3,t2,ResetMosca1
		
		addi t2,t2,4
		sw t2,4(t0)
		
		lw t2,8(t0)
		lh t3,0(t1)
		add t2,t2,t3
		sw t2,8(t0)
		
		lh t3,2(t1)
		addi t3,t3,16
		li t4,-4
		bne t2, t3, PularSobeDesce
		sh t4,0(t1)
		PularSobeDesce:
		lh t3,2(t1)
		addi t3,t3,-16
		li t4,4
		bne t2, t3, PularSobeDesce2
		sh t4,0(t1)
		PularSobeDesce2:
		j Fim_Mosca1
		ResetMosca1:
		li t2,-20
		sw t2,4(t0)
		li a7, 41
		ecall
		li t2,30
		rem a0,a0,t2
		addi a0,a0,120
		sh a0,2(t1)
		sw a0,8(t0)
		addi s8, s0, 10000
		Fim_Mosca1:
		
		
		#INIMIGO--->
		bltu s0, s7, Fim_Inimigo1
		
		la t0,Obj2
		lw a0 , 0(t0)
		lw a1 , 12(t0)
		lw a2 , 16(t0)
		lw a3 , 20(t0)
		call UnloadImage
		sw zero,0(t0)
		
		addi t0,s7,2000
		bltu s0, t0, Fim_Inimigo1
		
		li a7, 41
		ecall
		li t1, 3
		remu a0,a0,t1
		add a0,a0,a0
		add a0,a0,a0
		
		la t2, indio_pos2
		add t2,a0,t2
		lh t1, 0(t2)
		lh t2, 2(t2)
		la t0,Obj2
		sw t1,4(t0)
		sw t2,8(t0)
		la t3,inimigo
		sw t3,0(t0)
		
		li t3, 7
		mul a0,a0,t3
		la t3,Obj4
		add t3,t3,a0
		
		la t4,flecha
		sw t4,0(t3)
		li t5, 6
		sw t1,4(t3)
		sw t2,8(t3)
		sw t1,12(t3)
		sw t2,16(t3)
		sw t5,20(t3)
		
		addi s7, s0, 2000
		Fim_Inimigo1:
		#Fim Inimigo
		#Atualizar flechas
		bltu s0, s5, Fim_Flechas
		addi s5, s0, 30
		li t0,0
		For_Flechas:
		li t1,3
		beq t1,t0,Fim_Flechas
		li t2,28
		mul t2,t2,t0
		la t3, Obj4
		add t3,t3,t2
		lw t2, 0(t3)
		addi t0,t0,1
		beq zero, t2, For_Flechas
		lw t2, 8(t3)
		li t4,280
		bge t2, t4, For_Flechas
		addi t2,t2,4
		sw t2, 8(t3)
		j For_Flechas
		Fim_Flechas:

		#Inicio Relogio -->
		bltu s0, s6, AtualizarRelogio
		la t0, relogio_pos
		lb t2,0(t0)
		li t1,4
		bne t2,t1,PularFim_Relogio
		la t6, bananatotal
		lb t6,0(t6)
		li t5, 10
		blt t6,t5,Fim_GameTime
		j TerceiraParte
		Fim_GameTime:
		j FimGame
		PularFim_Relogio:
		addi t2,t2,1
		sb t2,0(t0)
		la a0 Relogio1
		li t3, 1736
		mul t3,t3,t2
		add a0,a0,t3
		li a1 , 270
		li a2 , 0
		li a3 , 6
		call LoadImage 
		addi s6, s0, 20000
		AtualizarRelogio:
	PularGameMoment1:
	#FIMGAMEMOMENT == 1
	
	call TocarMusica
	
	call Renderizador
	
	call GrowGarden
	FimGrowGarden:
	
	call SuperRenderv1				
						
	j GAME_LOOP
	
#######################################
#############FIM GAME_LOOP#############
#######################################

KeyDown:				#Recebe:
					# a0 - o endereco de controle do KDMMIO
  	lw t2,4(a0)  			# a1 - recebe ponto na tela que deve ser analizadp
		
	#Variaveis para atingir o ponto atual
	la t6,array_layers
	la t5, Obj1
	lw t3, 4(t5)
	lw t4, 8(t5)
	#operações para chegar no ponto certo
	add t6,t6,t3
	li t3,320
	mul t4,t4,t3
	add t6,t4,t6
	li t4,8640
	add t6,t6,t4
	# t6 recebe o valor do pixel na tela desejado q é o ponto esquerdo inferior
	
	li t0, 'p'
	li t1, 'P'
	
	beq t2,t0, PauseScreen
	beq t2,t1, PauseScreen
	
	###CHEATS###
	li t0, '('
	beq t2,t0, CheatVida
	
	li t0, ')'
	beq t2, t0, CheatPowerUp
	###CHEATS###
	
	
	li t0, 'e'
	li t1, 'E'

	beq t2,t0, SpaceInteraction
	beq t2,t1, SpaceInteraction
	
	#Se delay esta acontecendo ele nao pode se mover
	bltu s0,s10, FIM
	addi s10,s0,40
	#Troca a posição antiga com a atual e carrega t5 com char_pos
	la t5, Obj1
	addi t5,t5,4
	
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
		
		lw t2, 0(t5)
		addi t2, t2,4
		sw t2, 0(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		blt t1, t2, FIM
		sb zero,0(t0)

		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall			
		ret
		
	MoveLeft:
		addi t6,t6,-4
		
		lb t2,0(t6)
		li t6,-110
		beq t2,t6,FIM
		
		lw t1,0(t5)
		addi t1, t1, -4
		sw t1, 0(t5)
		
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
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
		
		
	MoveUp:
		addi t6,t6,-1280
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lw t1, 4(t5)
		addi t1, t1, -4 
		sw t1, 4(t5)
		
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
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
		
	MoveDown:

		addi t6,t6,1280
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lw t1, 4(t5)
		addi t1, t1, 4 
		sw t1, 4(t5)
		
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
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
		
	MoveDownRight:
		addi t6,t6,1284
		lb t2,0(t6)
		li t3,-110
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		
		li t3,63
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		
		
		addi s10,s10,20
		
		lw t2, 0(t5)
		addi t2, t2,4
		sw t2, 0(t5)
		lw t2, 4(t5)
		addi t2, t2,4
		sw t2, 4(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		blt t1, t2, FIM
		sb zero,0(t0)
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
		
	MoveUpRight:
		addi t6,t6,-1276
		lb t2,0(t6)
		li t3,-110
		
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		li t3,63
		
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		
		addi s10,s10,20
		
		lw t2, 0(t5)
		addi t2, t2,4
		sw t2, 0(t5)
		lw t2, 4(t5)
		addi t2, t2,-4
		sw t2, 4(t5)
		
		la t0, sprite_macaco
		lb t1,0(t0)
		addi t1,t1,1
		li t2,4
		sb t1,0(t0)
		blt t1, t2, FIM
		sb zero,0(t0)
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
	
	MoveUpLeft:
		addi t6,t6,-1284
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		addi s10,s10,20
		
		lw t1, 4(t5)
		addi t1, t1, -4 
		sw t1, 4(t5)
		lw t1, 0(t5)
		addi t1, t1, -4 
		sw t1, 0(t5)
		
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
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
	
	MoveDownLeft:
		addi t6,t6,1276
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM
			
		addi s10,s10,20

		lw t1, 4(t5)
		addi t1, t1, 4 
		sw t1, 4(t5)
		lw t1, 0(t5)
		addi t1, t1, -4 
		sw t1, 0(t5)
		
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
		li a0,38
		li a1,700
		li a2, 125
		li a3 , 80
		li a7,31
		ecall	
		ret
.include "data/funcoes.asm"
