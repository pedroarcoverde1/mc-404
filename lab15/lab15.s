.bss                     
.global isr_stack_end               # faz a pilha da isr global
.align 2
isr_stack_init:
.skip 1024
isr_stack_end:
.align 2

.data
.global x
.global y
.global z

x: .word 0          # rótulo que vai armazenar a coordenada x do carro
y: .word 0          # rótulo que vai armazenar a coordenada y do carro
z: .word 0          # rótulo que vai armazenar a coordenada z do carro

.text
.set BASE_ADRESS, 0xFFFF0100
.align 4

int_handler:

    csrrw sp, mscratch, sp          # sp agora aponta pra pilha da isr
    addi sp, sp, -32
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    sw a7, 32(sp)
    
    # código para lidar com a isr
    
    li a4, BASE_ADRESS              # carrego o endereço do periferico em a4

    # códigos de syscall
    li t0, 10
    li t1, 11
    li t2, 12
    li t3, 15

    beq a7, t0, drive
    beq a7, t1, break    
    beq a7, t2, read_line
    beq a7, t3, get_pos
    j 1f
    
    drive:
    sb a0, 0x21(a4)             # acelera 
    sb a1, 0x20(a4)             # aplica a esquerda
    j 1f
    
    break:
    sb a0, 0x22(a4)
    j 1f
    
    read_line:
    sb a0, 0x01(a4)
    j 1f
    
    get_pos:
    li t0, 1
    sb t0, 0(a4)                # pega a posição no gps

    lw t1, 0x10(a4)             # carrega a posição x
    lw t2, 0x14(a4)             # carrega a posição y
    lw t3, 0x0C(a4)             # carrega a psoição z

    sw t1, 0(a0)                # salva valor de x em x
    sw t2, 0(a1)                # salva valor de y em y
    sw t3, 0(a2)                # salva valor de z em z
        
    1:
    # retornar contexto
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp) 
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    lw a7, 32(sp)
    
    addi sp, sp, 32
    csrrw sp, mscratch, sp          # sp agora aponta pra pilha da isr

    csrr t0, mepc                   # load return address (address of
                                    # the instruction that invoked the syscall)
    addi t0, t0, 4                  # adds 4 to the return address (to return after ecall)
    csrw mepc, t0                   # stores the return address back on mepc
mret                            # Recover remaining context (pc <- mepc)


.globl _start
 _start:

    la t0, isr_stack_end
    csrw mscratch, t0               # inicio a pilha da isr

    la t0, int_handler              # cadastra isr 
    csrw mtvec, t0                  
     
    csrr t1, mstatus                # update the mstatus.MPP
    li t2, ~0x1800                  # field (bits 11 and 12)
    and t1, t1, t2                  # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, user_main                # load the user software
    csrw mepc, t0                   # entry point into mepc
mret                                # Salta para `user_main` no modo de usuário

# syscall_set_engine_and_steering -> Code: 10

# syscall_set_hand_brake -> Code: 11

# syscall_get_position -> Code: 15 

.globl control_logic
control_logic:

    # depende da coordenada
 
    dirige:
    # carrega o endereço das coordenadas
    la a0, x                    # X
    la a1, y                    # Y
    la a2, z                    # Z
    li a7, 15                   # code 15 -> GPS
    ecall

    lw a0, 0(a0)                # a1 contém a posição x
    lw a1, 0(a1)                # a2 contém a posição y
    lw a2, 0(a2)                # a3 contém a posiçãi z

    li t1, -40
    li t2, 135
    blt a2, t1, end             # enquanto Z for menor que -40 acelera
    beq a0, t2, freia           # enquanto x for maior q 100 acelera

    li a0, 1                    # joga o valor de t0 no a0
    li a1, -15                  # joga o valor de -15 para angulo da roda
    li a7, 10                   # code 10 -> drive
    ecall

    j dirige                    # faz um loop

    freia:
    
    li a0, 1                    # joga 1 no valor de a0
    li a7, 11                   # code 11 -> break
    ecall
    
    end:
    
    li a0, 1                    # joga 1 no valor de a0
    li a7, 11                   # code 11 -> break
    ecall
    j end