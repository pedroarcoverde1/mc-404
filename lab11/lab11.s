# controlando um carro
# endereço base do periférico -> 0xFFFF0100
.text
.set BASE_ADRESS, 0xFFFF0100
.global _start
_start:

drive:              
# ponto de saída (x = 180, y = 2,6, z = -108)
# ponto de chegada (x = 73, y = 1, z = -19)
# uma série de comparações de forma a alinhar com a saída
li a0, BASE_ADRESS
#loop de fazer o carro acelerar
#depende da coordenada
li t0, 1
li t1, -40                  # para valores menores quero movimento
li t3, 135                  # para valores maiores quero movimento
li t5, 1

dirige:
sb t5, 0(a0)                # pega a posição no gps

lw a1, 0x10(a0)             # X
lw a2, 0x14(a0)             # Y
lw a3, 0x0C(a0)             # Z

blt a3, t1, exit            # enquanto Z for menor que -40 acelera
beq a1, t3, freia           # enquanto x for maior q 100 acelera
sb t0, 0x21(a0)             # acelera 
li t2, -15                  # joga o grau de virada pra esquerda
sb t2, 0x20(a0)             # aplica a esquerda
j dirige                    # faz um loop

freia:
li t4, 1
sb t4, 0x22(a0)
li t0, 0
j dirige

exit:
li a0, 0
li a7, 93
ecall