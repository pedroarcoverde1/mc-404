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


adiciona_pixel:
lbu t3, 0(t0)                   # carrega o pixel
mul t3, t3, t1                  # multiplica por -1
add a1, a1, t3                  # adiciona no a1
ret

calcula_blur:                   # salvar ra antes de acessar essa função

addi sp, sp, -4                 # Salvar conteúdo de RA
sw ra, (sp)                     # na pilha do programa
                                # função para calcular o blur da imagem
#dado o pixel selecionado devo realizar uma soma de convolução de acordo com a matriz dada

mv t0, a5                       # pixel selecionado
li t1, -1                       # valores perifericos
li t2, 8                        # multiplicador do pixel
addi t6, s2, 1

# pensando em termos de buffer
/* soma = 8*buff[pos_atual] +
-1* buff[max_col-pos_atual- 1] + 
-1*buff[max_col-pos_atual] + 
-1* buff[max_col - pos_atual+1] + 
-1*buff[max_col+ pos_atual-1]+
-1*buff[max_col+ pos_atual]+
-1*buff[max_col+pos_atual+1] */

# variáveis de colunas s5 -> col_atual / s2--> max_colunas
# variáveis de linhas s4-> linha_atual / s3-> max_linhas

#linha do meio
lbu a1, 0(t0)                   # valor do meio    
mul a1, a1, t2                  # 8*buff[pos_atual]

addi t0, t0, -1                 # valor da esquerda
jal adiciona_pixel

addi t0, t0, 2                  # valor da direita
jal adiciona_pixel

#linha de cima
sub t0, a5, t6                  # 1 linha a cima -> mesma coluna
jal adiciona_pixel              # adiciona em a1

addi t0, t0, -1                  # pixel da esquerda
jal adiciona_pixel              # adiciciona em a1

addi t0, t0, 2                   # vai para o pixel da direita
jal adiciona_pixel              # adiciciona em a1

# linha de baixo
add t0, a5, t6                 # 1 linha a baixo, mesma coluna
jal adiciona_pixel              # adiciona em a1

addi t0, t0, -1                 # pixel da esquerda
jal adiciona_pixel              # adiciona em a1

addi t0, t0, 2                  # pixel da direita
jal adiciona_pixel              # adiciona em a1



lw ra, (sp) # Recuperar conteúdo de
addi sp, sp, 4 # RA da pilha
ret # Retornar

paint_black:
li t1, 0x000000FF
j done_pixel

main:
                                # função de ler o arquivo
jal get_image
                                # tenho um buffer com todas o arquivo de imagem

la a5, buffer_pgm               # carraga  o endereço do buffer para a0

# ler a primeira linha do buffer

li a3, 10                       # valor de um '\n'
li a4, 32                       # valor de um ' '

skip_magic_num:
addi a5, a5, 3                  # pula 3 bytes "P" "2" "\n"

li t1, 0
li s2, 0                        # width
li s3, 0                        # height

width:
lbu t0, 0(a5)                   # carrega o caractere de da posição de a5
beq t0, a4, pass                # se t0 for igual a espaço eu simplesmente avanço o buffer
# conversão para ascii
addi t0, t0, -48                # tira a mascara do ascii
mul s2, s2, a3                  # multiplica pela base 10
add s2, s2, t0                  # adicina o valor convertido ao t1
addi a5, a5, 1                  # avança o buffer
j width

pass:
addi a5, a5, 1                  # pula para a conversão de height

height:
lbu t0, 0(a5)
beq t0, a3, done                # acaba se encontrar um \n
addi t0, t0, -48                # tira a mascara do ascii
mul s3, s3, a3                  # multiplica pela base 10
add s3, s3, t0                  # adicina o valor convertido ao t1
addi a5, a5, 1                  # avança o buffer
j height

done:

jal setCanvasSize               # ajusto o tamanho do canva

# pula para a linha de val max
addi a5, a5, 5                  # pula "2" "5" "5" "\n"
                                # s2 -> width
                                # s3 -> height


addi s2, s2, -1                 

li s4, 0                        # linhas--> y
li s5, 0                        # colunas--> x

image_loop:

lbu t1, 0(a5)                   # leio o pixel 

addi t0, s3, -1
beqz s4, paint_black            # verificar se eu estou na primeira linha
beq s4, t0, paint_black         # verificar se eu estou na ultima linha
beqz s5, paint_black            # verificar se eu estou na primeira coluna
beq s5, s2, paint_black         # verificar se eu estou na ultima coluna

jal calcula_blur                # aplica o blur na imagem
mv t1, a1

li t0, 255
blt t1, zero, faz_zero
bgt t1, t0, faz_255
j converte_pixel                # se está no range certo vai para a conversão

faz_zero:                       # se o numero for menor que 0 o numero é 0
li t1, 0x000000FF
j done_pixel

faz_255:                        # se o numero é maior q 255 ele é 255
li t1, 0xFFFFFFFF
j done_pixel

converte_pixel:
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
li t5, 0x000000FF               # Define alpha = 255 (A = 255)
#and t5, t5, t0
or t1, t1, t5                   # Combina R, G, B e A em t2


done_pixel:
jal set_pixel
beq s5, s2, new_line            # TODO: ando como o buffer até chegar no numero de colunas


addi s5, s5, 1                  # incremento o valor da coluna junto com o valor do buffer
addi a5, a5, 1                  # anda com o buffer

j image_loop

new_line:
addi s4, s4, 1                  # atualizar o valor de linha
li s5, 0                        # resetar o valor de coluna
beq s4, s3, end_loop            # loop externo, quantidade de linhas
addi a5, a5, 1                  # adicionar 1 no buffer
j image_loop                    # volta para o loop de imagem

end_loop:
li a7, 93                       # call de exit
ecall



.data
input_file: .asciz "image.pgm"

.bss
buffer_pgm: .skip 262200
