.section .text
.global _start

_start:
call main


get_image:
# leitura de um arquivo pgm -> o nome veme m ascii
la a0, input_file               # abrir o arquivo
li a1, 0                        # ler o arquivo
li a2, 0                        # fechar o arquivo
li a7, 1024                     # ter um buffer com as informações do arquivo
ecall

# file descriptor estava no a0 --> s1

la a1, buffer_pgm               # qual o tamanho maximo do buffer?
li a2, 262200                   # não sei o tamanho o buffer ainda
li a7, 63
ecall

                                # função para fechar o arquivo

li a7, 57
ecall
ret


set_pixel:                      # vai ser implementada como um for dentro de um for
mv a0, s5                       # TODO:coordenadas de x --> coluna
mv a1, s4                       # TODO:coordenadas de y --> linha
mv a2, t1   
li a7, 2200
ecall
ret


setCanvasSize:
# fazer o load do width e height antes de acessar a função
mv a0, s2                       # a0 -> canvas width
mv a1, s3                       # a1 -> canvas height
li a7, 2201
ecall
ret

main:
# função de ler o arquivo
jal get_image
# tenho um buffer com todas o arquivo de imagem

la a5, buffer_pgm           # carraga  o endereço do buffer para a0

# ler a primeira linha do buffer

li a3, 10                   # valor de um '\n'
li a4, 32                   # valor de um ' '

skip_magic_num:
addi a5, a5, 3              # pula 3 bytes "P" "2" "\n"

li t1, 0
li s2, 0                    # width
li s3, 0                    # height

width:
lbu t0, 0(a5)               # carrega o caractere de da posição de a5
beq t0, a4, pass            # se t0 for igual a espaço eu simplesmente avanço o buffer
# conversão para ascii
addi t0, t0, -48            # tira a mascara do ascii
mul s2, s2, a3              # multiplica pela base 10
add s2, s2, t0              # adicina o valor convertido ao t1
addi a5, a5, 1              # avança o buffer
j width

pass:
addi a5, a5, 1              # pula para a conversão de height

height:
lbu t0, 0(a5)
beq t0, a3, done            # acaba se encontrar um \n
addi t0, t0, -48            # tira a mascara do ascii
mul s3, s3, a3              # multiplica pela base 10
add s3, s3, t0              # adicina o valor convertido ao t1
addi a5, a5, 1              # avança o buffer
j height

done:

jal setCanvasSize           # ajusto o tamanho do canva

# pula para a linha de val max
addi a5, a5, 5                  # pula "2" "5" "5" "\n"

addi s2, s2, -1
#addi s3, s3 , -1

li s4, 0                        # linhas--> y
li s5, 0                        # colunas--> x

image_loop:

lbu t1, 0(a5)                   # leio o pixel 

# Assumindo que `t1` possui o valor de cinza (gray_value)
# Assumindo que `t1` possui o valor de cinza (gray_value)
#TODO: tentar fazer uma mask
li t0, 0xFF000000

slli t2, t1, 24                 # Shift para a esquerda para formar R (t2 = R << 24)
and t2, t2, t0
or t1, t1, t2

li t0, 0x00FF0000
slli t3, t1, 16                 # Shift para a esquerda para formar G (t3 = G << 16)
and t3, t3, t0
or t1, t1, t3                   # Combina R e G em t2

li t0, 0x0000FF00
slli t4, t1, 8                  # Shift para a esquerda para formar B (t3 = B << 8)
and t4,t4, t0
or t1, t1, t4                   # Combina R, G e B em t2

#li t0, 0x000000FF
li t5, 0x000000FF                      # Define alpha = 255 (A = 255)
#and t5, t5, t0
or t1, t1, t5                   # Combina R, G, B e A em t2

jal set_pixel

beq s5, s2, new_line            # TODO: ando como o buffer até chegar no numero de colunas


addi s5, s5, 1                  # incremento o valor da coluna junto com o valor do buffer
addi a5, a5, 1                  # anda com o buffer

j image_loop

new_line:
addi s4, s4, 1              # atualizar o valor de linha
li s5, 0                    # resetar o valor de coluna
beq s4, s3, end_loop            # loop externo, quantidade de linhas
addi a5, a5, 1              # adicionar 1 no buffer
j image_loop                # volta para o loop de imagem

end_loop:
li a7, 93                   # call de exit
ecall



.data
input_file: .asciz "image.pgm"

.bss
buffer_pgm: .skip 262200
