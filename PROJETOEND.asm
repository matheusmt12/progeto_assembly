.data
	corredor1: .byte
		   .align 0
		   .space 6
	corredor2: .byte
		   .align 0
		   .space 6
	corredor3: .byte
		   .align 0
		   .space 6
	pergunta: .asciiz "qual * voce deseja abrir :"
	num1: .byte 'A'
	num2: .byte 'B'
	num3: .byte 'P'
	vazio: .byte '*'
	pulalinha : .byte '\n'
	dadosv1: .byte '1'
	dadosv2: .byte '2'
	dadosv3: .byte '3'
	usa: .byte 'X'
	campeao: .asciiz "O campeão foi o : "
	resultadofinal: .asciiz "Gabarito  :  \n"
	jogarn: .asciiz "\n \n \n deseja jogar novamnete ? digite 1 caso nao queira, aperte outro numero :"
	numrep: .asciiz "numero repetido, degite ontro :"

	
	graf1: .byte '|'
       
	vetorc1: .byte  #VETOR PRINCIPAL 
		 .align 0
		 .space 16
	vetorc2: .byte
		 .align 0
		 .space 16
.text
	
	# Ao terminar o jogo pergunta se quer jogar novamente 
	jogarnovamente:
	
	# para pular linha
	li $v0,11
 	lb $a0,pulalinha
	syscall
 	lb $a0,pulalinha
	syscall
	#===================
	li $t4,0
	li $t5,0
	li $t6,0	
	li $t2,1 # preencido para participar do loop do for
	li $s3,16 # participar do loop for
	li $s1,1
	li $s2,6
	# carregar caracteres de A & B & P
	lb $s4,num1
	lb $s5,num2
	lb $s6,num3
	#========================
	li $t1,1
	li $t3,1
	li $t9,1


	#carregar caracteres nos determinados vetores 
	forcr :
	beq $s1,$s2,sairforcr  #preencher A, B e P
	  sb $s4,corredor1($s1)#s1 o contador
	  sb $s5,corredor2($s1)
   	  sb $s6,corredor3($s1)
	  addi $s1,$s1,1 #ACRESCENTA MAIS UM
	j forcr
	sairforcr:
	
	#==============================================
	lb $s1,vazio 
	#for para preencher vetores, aleatorio(A & B & P) e o vazio
	for:
	beq $t2,$s3, sair #condicao para ser menor que 16
	jal numale # UM NUMERO ALEATORIO
	jal preencher
	sb $a0, vetorc1($t2)
	sb $s1, vetorc2($t2) # vetor 2 só asterico, na medida que ojogo acontece o asterico somde
	addi $t2,$t2,1
	j for
	sair:
	
	#===============================================
	
         # PRA PREENCGER O VETOR
	li $t8,1
	li $t7,17
	
	# 	
	li $t4,0
	li $t5,0
	li $t6,0
	#comeco do jogo
	# laço para as jogadas, ###### laço do jogo ######
	while:
	
	jal imprimir 
	lb $a0,pulalinha
	syscall
	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,pergunta
	syscall
	
	numerorep:
	#escolher vetor desejado+++++++++++++++++++++	
	jal escolherposicao
	
	move $t0,$a0
	# ===================
	
	#Funçao para ser usada caso o vetor ja tenha sido utilizado
	jal novamente
	lb $a0,vetorc1($t0)
	sb $a0,vetorc2($t0) 
	
	jal jogadas
	jal exibircoredores
	
	#condiçao para quando ouver um vencedor
	beq $t4,5, venceuA
	beq $t5,5, venceuB
	beq $t6,5, venceuC
	

	j while
	###### laco do jogo #######
	
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	preencher : #funçao para retornar um caracter, seja ele A, B ou P
	bne $a0,1,exitif # SE O a0 == 1 ||
	prox2:           # tem um contador, para cada letra
	beq $t4,5,prox   
	addi $t4,$t4,1 #contador
	lb $a0,num1
	jr $ra
        exitif:
        bne $a0,2,exitif1
        prox:
        beq $t5,5,prox1
        addi $t5,$t5,1 #contador
        lb $a0,num2
        jr $ra
        exitif1:
        bne $a0,3,exitif3
        prox1:
        beq $t6,5,prox2
	addi $t6,$t6,1 #contador
        lb $a0,num3
        jr $ra
	exitif3 :
	
	#============================================
	#Funçao que retorna um numero 1 a 3
	numale:	
        addi $v0,$zero,42   
        addi $a1,$zero,4    
        add $a0,$a0,$zero   
        syscall
      
        addi $t0,$zero,0   
        bne $a0,$t0,sairif 
        addi $a0,$zero,1
        sairif:

        jr $ra 
	
	#escolher numero de determinada posiçao
	escolherposicao:#aqui é onde o usuario escolhe a posicao do vetor aleatorio
	li $v0,5 # so ta lendo  que o usuario digitou
	syscall
	move $a0,$v0
	jr $ra
	#=======================================
	
	#modificar vetor do corredor caso a posiçao dele seja achada
	jogadas:
	
	lb $s4,num1 ### A
	lb $s5,num2 ### B
	lb $s6,num3 ### P
	
	bne $a0,$s4,pula #IF
	lb $a0,usa  ### é o x, usado para marcar
	sb $a0,corredor1($t3)
	addi $t3,$t3,1	
	addi $t4,$t4,1  #contador para guarda a posicao que tá
	jr $ra          # um if para cada um, A, B e P
	pula:
	bne $a0,$s5,pulap#IF
	lb $a0,usa
	sb $a0,corredor2($t1)
	addi $t1,$t1,1 #contador
	addi $t5,$t5,1
	jr $ra
	pulap:
	bne $a0,$s6,pulapr #if
	lb $a0,usa
	sb $a0,corredor3($t9)
	addi $t9,$t9,1  #contador
	addi $t6,$t6,1
	jr $ra
	pulapr:
	jr $ra
	#final de jogadas
	#===============================================
	
	#função que exibe a posiçao de cada jogador 
	exibircoredores: # o que é alterado em jogadas na memoria, é exibido aqui
	li $s1,0         # um laco para cada corredor
	li $v0,11
	e:
	beq $s1,$s2,s 
	lb $a0,graf1
	syscall
	lb $a0,corredor1($s1)
	syscall
	lb $a0,graf1
	syscall
	addi $s1,$s1,1

	j e
	s:
	li $s1,0
	lb $a0,pulalinha
	syscall
	
	ex:
	beq $s1,$s2,sa
	lb $a0,graf1
	syscall
	lb $a0,corredor2($s1)
	syscall
	lb $a0,graf1
	syscall
	addi $s1,$s1,1
	
	
	j ex
	sa:
	li $s1,0
	lb $a0,pulalinha
	syscall
	
	exi:
	
	beq $s1,$s2,sai
	lb $a0,graf1
	syscall
	lb $a0,corredor3($s1)
	syscall
	lb $a0,graf1
	syscall
	addi $s1,$s1,1
	
	j exi
	sai:
	li $s1,0
	lb $a0,pulalinha
	syscall
	
	jr $ra
	#termino da funcao de exibir jogadores
 	#====================================================

 	#usada para n permitir que o mesmo numero seja utilizado
 	novamente: # caso digite um numero errado
 	lb $a0,vetorc2($t0)
 	lb $a1,vazio
 	bne $a0,$a1,numerorep
 	jr $ra
 	#===================================================
 	#imprime as posiçoes que tem para achar e as que ja foram achadas 
 	imprimir:  # vetor 2 só asterico, na medida que ojogo acontece o asterico somde
 	
	li $t2,0
	#imprimir vetores ********
	impvetorvazio: #imprimir as reposta do usuario
	beq $t2,$s3, sairimp
	li $v0,11
	lb $a0,graf1
	syscall
	lb $a0,vetorc2($t2)
	syscall	
	lb $a0, graf1
	syscall
	addi $t2,$t2,1
	j impvetorvazio
	sairimp:
 	jr $ra
 	#=============================================
 	
 	#caso o jogador A vença
 	venceuA:
 	jal imprimir
  	li $t2,1
 	li $s3,16
 	li $v0,11
 	lb $a0,pulalinha
 	syscall
 	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,campeao
	syscall
	li $v0,11
 	lb $a0, num1
 	syscall
  	lb $a0,pulalinha
	syscall
  	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,resultadofinal
	syscall
	li $v0,11 #imprimir em bytes
  	lb $a0,pulalinha
	syscall
  	impvetorvazio1:
	beq $t2,$s3, sairimp1
	li $v0,11
	lb $a0,graf1
	syscall
	lb $a0,vetorc1($t2)
	syscall	
	lb $a0, graf1
	syscall
	addi $t2,$t2,1
	j impvetorvazio1
	sairimp1:
  	
  	li $v0,4
 	la $a0, jogarn
 	syscall
 	li $v0,5
 	syscall
 	move $a0,$v0
 	beq $a0,1, jogarnovamente
 	li $v0,10
 	syscall
 
 	#caso o jogador B vença
  	venceuB:
   	jal imprimir
   	li $t2,1
 	li $s3,16
 	li $v0,11
 	lb $a0,pulalinha
	syscall
 	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,campeao
	syscall
	li $v0,11
 	lb $a0, num2
 	syscall
  	lb $a0,pulalinha
	syscall
  	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,resultadofinal
	syscall
	li $v0,11
  	lb $a0,pulalinha
	syscall
  	impvetorvazio2:
	beq $t2,$s3, sairimp2
	li $v0,11
	lb $a0,graf1
	syscall
	lb $a0,vetorc1($t2)
	syscall	
	lb $a0, graf1
	syscall
	addi $t2,$t2,1
	j impvetorvazio2
	sairimp2:
	
 	li $v0,4
 	la $a0, jogarn
 	syscall
 	li $v0,5
 	syscall
 	move $a0,$v0
 	beq $a0,1, jogarnovamente
 	li $v0,10
 	syscall

  	#caso o jogador  jogador P vença
  	venceuC:
   	jal imprimir
   	li $t2,1
 	li $s3,16
 	li $v0,11
 	lb $a0,pulalinha
	syscall
 	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,campeao
	syscall
	li $v0,11
 	lb $a0, num3
 	syscall
  	lb $a0,pulalinha
	syscall
  	lb $a0,pulalinha
	syscall
	li $v0,4
	la $a0,resultadofinal
	syscall
	li $v0,11
  	lb $a0,pulalinha
	syscall
 	impvetorvazio3:
	beq $t2,$s3, sairimp3
	li $v0,11
	lb $a0,graf1
	syscall
	lb $a0,vetorc1($t2)
	syscall	
	lb $a0, graf1
	syscall
	addi $t2,$t2,1
	j impvetorvazio3
	sairimp3:
 	
 	li $v0,4
 	la $a0, jogarn
 	syscall
 	li $v0,5
 	syscall
 	move $a0,$v0
 	beq $a0,1, jogarnovamente
 	li $v0,10
 	syscall
	
	
