.data
Music_config: 	.word 13,0,28,30  #notas total, nota atual, instrumento, volume
Notas: 		.word 69,250,76,250,74,250,76,250,79,300, 76,500,0,600,69,250,76,250,74,250,76,250,81,300,76,500

.text	
	li a0, 200
	li a7, 32
	ecall

	TocarMusica:#s11 é o contador

	
	
	#li a7,30		# coloca o horario atual em a0
	#ecall
 	Set_TM:
 		#blt a0,s11, Fim_TM
		la t2,Music_config
 		lw t0, 0(t2)	#t0=notas total
 		lw t1, 4(t2)	#t1=nota atual
 		lw a2, 8(t2)	#a2=instrumento
 		lw a3, 12(t2)	#a3=volume
		
			If_TM:
				bne t0, t1, TM
				sw zero, 4(t2)
				li t1, 0
			
		TM:
			la t4, Notas
			li t3, 8
			mul t1, t1, t3
			add t4, t4, t1
			lw a0,0(t4)		# le o valor da nota
			lw a1,4(t4)		# le a duracao da nota
			li a7,31		# define a chamada de syscall
			ecall			# toca a nota
			
			mv a0, a1
			li a7, 32
			ecall
			
			#li a7, 30
			#ecall
			
			mv a0,s11
			lw t4, 4(t4)
			add s11,s11,t4
	
			lw t6, 4(t2)
			addi t6,t6,1
			sw t6,4(t2)
			
		Fim_TM:
			j TocarMusica
