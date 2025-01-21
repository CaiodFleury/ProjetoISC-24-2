.data
.include "data/imagens.asm"
.include "data/config.asm"
.text
#Codigo vai comecar na main.
#Funcoes no final
#Padrao for/while/if : Loop_num
#Padrao funcoes FazerAlgo
#UNICA VARIAVEL GLOBAL É S11 q é o tempo atual
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
			
	#renderização
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
	
	
	la t0, indio_pos
	lh t1, 4(t0)
	beq t1, zero, Back2
	
	call Inimigo
	
Back1:	#
	
	la t0, old_indio_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 5
	la a0 inimigo
	call UnloadImage
	
	la t0, indio_pos
	lh a1 , 0(t0)
	lh a2 , 2(t0)
	li a3 , 5
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
	li a3 , 5
	la a0 , inimigo
	call LoadImage
	#
	
Skip:
	#
	
	call Renderizador
	
	#call TocarMusica #CHAMA A MUSICA. COLOQUEI AKI PQ FOI O LUGAR Q O DESEMPENHO FICOU MELHOR
		
	j GAME_LOOP

KeyDown:
	
  	lw t2,4(a0)  			# le o valor da tecla tecla
		
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
	
	li t0, 'm'
	li t1, 'M'
	beq t2, t0, MoveUpRight
	beq t2, t1, MoveUpRight
	
	li t0, 'j'
	li t1, 'J'
	beq t2, t0, MoveUpLeft
	beq t2, t1, MoveUpLeft
		
	li t0, 'k'
	li t1, 'K'
	beq t2, t0, MoveDownRight
	beq t2, t1, MoveDownRight
	
	li t0, 'n'
	li t1, 'N'
	beq t2, t0, MoveDownLeft
	beq t2, t1, MoveDownLeft

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
		ret
		
	MoveLeft:
		addi t6,t6,-4
		
		lb t2,0(t6)
		li t6,-110
		beq t2,t6,FIM
		
		lh t1,0(t5)
		addi t1, t1, -4
		sh t1, 0(t5)
		ret
		
	MoveUp:
		addi t6,t6,-1280
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lh t1, 2(t5)
		addi t1, t1, -4 
		sh t1, 2(t5)
		ret
		
	MoveDown:

		addi t6,t6,1280
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lh t1, 2(t5)
		addi t1, t1, 4 
		sh t1, 2(t5)
		ret
		
	MoveUpRight:
		addi t6,t6,-1276
		lb t2,0(t6)
		li t3,-110
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		li t3,63
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		lh t2, 0(t5)
		addi t2, t2,4
		sh t2, 0(t5)
		lh t2, 2(t5)
		addi t2, t2,4
		sh t2, 2(t5)
		ret
		
	MoveDownRight:
		addi t6,t6,1284
		lb t2,0(t6)
		li t3,-110
		beq t2,t3,FIM # se o pixel for azul ele não se meche
		li t3,63
		beq t2,t3,SegundaParte # se for amarelo ele vai para a segunda parte do mapa
		lh t2, 0(t5)
		addi t2, t2,4
		sh t2, 0(t5)
		lh t2, 2(t5)
		addi t2, t2,-4
		sh t2, 2(t5)
		ret
	
	MoveUpLeft:
		addi t6,t6,-1284
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lh t1, 2(t5)
		addi t1, t1, -4 
		sh t1, 2(t5)
		lh t1, 0(t5)
		addi t1, t1, -4 
		sh t1, 0(t5)
		ret
	
	MoveDownLeft:
		addi t6,t6,1276
		
		lb t4,0(t6)
		li t6,-110
		beq t4,t6,FIM

		lh t1, 2(t5)
		addi t1, t1, 4 
		sh t1, 2(t5)
		lh t1, 0(t5)
		addi t1, t1, -4 
		sh t1, 0(t5)
		ret
.include "data/funcoes.asm"
