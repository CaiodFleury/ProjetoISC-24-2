.data
.include "data/imagens.asm"
.include "data/config.asm"
.text
#Codigo vai comecar na main.
#Funcoes no final
#Padrao for/while/if : Loop_num
#Padrao funcoes FazerAlgo

main:	
	
	call StartScreen
	FimStartScreen:
	
	#colocar animaÃ§Ã£o de introduÃ§Ã£o aqui
			
	call LoadGame
	FimGame:
	
	call FimPrograma
			
#tela de inicio
StartScreen:
	li a1 , 0
	li a2 , 0
	la a0 ,startscreen
	call LoadScreen
	
	li a0, 2
	call TrocarTela	
	
	li a1 , 100
	li a2 , 100
	la a0 Loading
	call LoadScreen
	
	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,StartScreen  	# Se nao ha tecla pressionada entao vai para FIM			
	
	j FimStartScreen

#Administrador maximo do jogo
LoadGame:
	li a7,30		# coloca o horario atual em s11
	ecall
	add s11 , zero , a0
	
	#Primeira parte do nivel
	li a1 , 0
	li a2 , 0
	li a3 , 3
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
	
	call GAME_LOOP
	
#O game loop vai ser responsavel por administrar:
#efeitos visuais e coisas que mudam na tela
#receber teclas
#Modificacoes chamarao a renderizacao	
GAME_LOOP: 	

	li a0,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(a0)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,PularKeyDown   	# Se nao ha tecla pressionada entao vai para FIM			
	call KeyDown
	PularKeyDown:
	
	#j PularRenderizar
	Renderizar:
		
		#macaco
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
		la a0 , macaco
		call LoadImage
		
		call Renderizador
		
		#######
	PularRenderizar:
	
	call TocarMusica #CHAMA A MUSICA. COLOQUEI AKI PQ FOI O LUGAR Q O DESEMPENHO FICOU MELHOR
		
	j GAME_LOOP




KeyDown:
	
  	lw t2,4(a0)  			# le o valor da tecla tecla
		
		
	li t0, 'e'
	beq t2,t0, SpaceInteraction	
	
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
	
	SpaceInteraction:
		la t6,array_layers
		la t5, char_pos
		lh t0, 0(t5)
		lh t1, 2(t5)
		#operações para chegar no ponto certo
		add t6,t6,t0
		li t2,320
		mul t2,t2,t1
		add t6,t2,t6
		li t2,8640
		add t6,t6,t2
		lb t2,0(t6)
		li t3, 20
		bltu t2,t3,WaterGarden
		ret
	# t0 = x, t1 = y
	MoveRight:
		la t6,array_layers
		la t5, char_pos
		la t4, old_char_pos
		lw t0, 0(t5)
		sw t0, 0(t4)
		lh t0, 0(t5)
		lh t1, 2(t5)
		#operações para chegar no ponto certo
		addi t2, t0, 4
		add t6,t6,t2
		li t2,320
		mul t2,t2,t1
		add t6,t2,t6
		li t2,8640
		add t6,t6,t2
		#pega o bit e ve o valor
		lb t2,0(t6)
		li t3,-110
		beq t2,t3,FIM
		li t3,63
		beq t2,t3,SegundaParte
		addi t2, t0,4 
		sh t2, 0(t5)
		ret
		
	MoveLeft:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 0(t0)
		
		addi t5, t1, -4
		
		la t6,array_layers
		add t6,t6,t5
		li t5,320
		lh t2, 2(t0)
		mul t2,t2,t5
		add t6,t2,t6
		li t4,8640
		add t6,t6,t4
		lb t5,0(t6)
		li t6,-110
		beq t5,t6,FIM
		
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
		
		la t6,array_layers
		li t4,320
		mul t4,t4,t5
		lh t5, 0(t0)
		add t6,t6,t5
		add t6,t4,t6
		li t4,8640
		add t6,t6,t4
		lb t5,0(t6)
		li t6,-110
		beq t5,t6,FIM
		
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
		la t6,array_layers
		li t4,320
		mul t4,t4,t5
		lh t5, 0(t0)
		add t6,t6,t5
		add t6,t4,t6
		li t4,8640
		add t6,t6,t4
		lb t5,0(t6)
		li t6,-110
		beq t5,t6,FIM
		
		addi t1, t1, 4 # 56 bits pra esquerda
		sh t1, 2(t0)
		ret

.include "data/funcoes.asm"