.data
	vetor:  .byte 0x25
	video:  .word 0xff000000
	newl:   .string "\n"
	tab:   	.string "\t" 
.text
main:	li t0, 0        # Inicializa o contador i = 0
    	li t1, 76800       # Carrega o valor 10 em t1 (limite superior do loop)
    	li s1, 0xff000000
    	
FOR1:	bge t0, t1, loop_end   # Se t0 >= t1, sai do loop

    	li s0, 0x42  
	sb s0,0(s1)
    
    	addi s1, s1, 1    # Incrementa s1 (i++)
    	addi t0, t0, 1    # Incrementa t0 (i++)
    	j FOR1      # Volta para o início do loop

loop_end:
	li a7,10
	ecall	 