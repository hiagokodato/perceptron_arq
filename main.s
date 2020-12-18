.data


# A entrada sera representada como x, que vai de 1 em 1 até 100
# A saida esperada sera representada como 'a' que vai de 2 em 2 até 200

x: .float 1.0
a: .float 2.0
z1: .float 0.3
z2: .float -0.1
aprendizado: .float 0.0001
novovalor: .float 500.0
mensagem1: .asciiz "Resultado: "
mensagem2: .asciiz "Taxa de erro: "
breakline: .asciiz "\n"
.text
.globl main
main:

# Valores iniciais

la $t7, x
lwc1 $f8, 0($t7)
lwc1 $f2, 4($t7)
lwc1 $f6, 8($t7)
lwc1 $f4, 12($t7)
lwc1 $f24, 16($t7)


# Declarando variavel 'index'
addi $t0, $zero, 1

# Declarando iteracoes para trinta
addi $t1, $zero, 30

TESTE1:

# Comparar $t0 (index) a $t1 
slt $t2, $t0, $t1

# Se $t2 = 0 (i >= 30), JUMP TESTENOVOVALOR
beq $t2, $zero TESTENOVOVALOR

# armazenar x * z1 no registrador $f10
mul.s $f10, $f6, $f8

# armazenar x * z2 no registrador $f12
mul.s $f12, $f4, $f8

# armazenar $f10 + $f12 no registrador $f14
add.s $f14, $f10, $f12

# armazenar $f1 - $f12 no registrador $f16
sub.s $f16, $f2, $f14

# armazenar o erro * taxa de aprendizado no registrador $f18
mul.s $f18, $f16,  $f24

# armazenar $f18 (erro * taxa de aprendizado) * a (entrada) em $f20
mul.s $f20, $f18, $f2

# armazenar $f20 + $f6 em $f6 (z1 = z1 + (erro * taxaAprendizado * a))
add.s $f6, $f6, $f20

# armazenar $f20 + $f4 em $f4 (z2 = z2 + (erro * taxaAprendizado * a))
add.s $f4, $f4, $f20

# incrementar o x
lwc1 $f20, 0($t7)
add.s $f8, $f8, $f20

# incrementar o a
lwc1 $f22, 4($t7)
add.s $f2, $f2, $f22

# incrementar o index
addi $t0, $t0, 1

j TENTATIVAS

TESTENOVOVALOR:

# Adicionar um novo valor ao registrador $f18
lwc1 $f18, 20($t7)

# armazenar x * z1 no registrador $f12
mul.s $f12, $f6, $f18

# armazenar x * z2 no registrador $f10
mul.s $f10, $f4, $f18

# armazenar $f10 + $f12 (result) no registrador $f16
add.s $f16, $f10, $f12

# armazenar $f28 * 2 (dobro do valor testado) - $f16  (erro) no registrador $f14
lwc1 $f28, 4($t7)
mul.s $f28, $f28, $f18
sub.s $f14, $f28, $f16

# mensagem1
li $v0, 4 
la $a0, mensagem1
syscall

# Resultado 
mov.d $f12, $f16
li $v0, 2
syscall

# Quebra de linha
li $v0, 4
la $a0, breakline
syscall

# mensagem2
li $v0, 4
la $a0, mensagem2
syscall

# Taxa de erro
mov.d $f12, $f14
li $v0, 2
syscall


END:
jr $ra