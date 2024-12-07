.data

.global _system_time                # define _system_time como global
_system_time: .word 0               # incializa como zero

.bss                     
.global isr_stack_end               # faz a pilha da isr global
.align 2
isr_stack_init:
.skip 1024
isr_stack_end:

.text
.global play_note                   # faz a função playnote global
.global isr                         # faz a isr global
.global _start                      # faz a função start global

_start:
    #la sp, program_stack_end        # inicio a pilha do programa

    # Registrar a ISR
    la t0, isr                      # Grava o endereço da ISR principal
    csrw mtvec, t0                  # no registrador mtvec

    la t0, isr_stack_end
    csrw mscratch, t0               # inicio a pilha da isr

    # Habilita Interrupções Externas
    csrr t1, mie                    # Seta o bit 11 (MEIE)
    li t2, 0x800                    # do registrador mie [100000000000]
    or t1, t1, t2
    csrw mie, t1
    # Habilita Interrupções Global
    csrr t1, mstatus                # Seta o bit 3 (MIE)
    ori t1, t1, 0x8                 # do registrador mstatus (100)
    csrw mstatus, t1

    li t0, 100
    li a0, 0xFFFF0108
    sw t0, 0(a0)                     # programa o timer para interromper em intervalos de 100 ms
jal main

isr:
    # salvar contexto
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

    li t0, 1                        # joga 1 em t0
    li a0, 0xFFFF0100               # carrega o endereço base do tiemer
    sb t0, 0(a0)                    # ativa a leitura do timer

    # pooling
    #1:
    #lb t1, 0(a0)                    # carrega o byte do endereço
    #beqz t1, 1f                     # se for igual a zero avança
    #j 1b                            # se n for igual a 0, repete
    
    1:
    la t0, _system_time             # carrega o endereço do _system_time em t0
    lw t2, 0(t0)
    addi t2, t2, 100
    sw t2, 0(t0)                    # salva o tempo no programa

    # resetar o timer 
    li t0, 100
    sw t0, 8(a0)                     # programa o timer para interromper em intervalos de 100 ms

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
mret

play_note:
    # a0 -> int ch
    # a1 -> int inst
    # a2 -> int note
    # a3 -> int vel 
    # a4 -> int dur
    li t1, 0xFFFF0300
    sb a0, 0(t1)                 # salva ch
    sh a1, 2(t1)
    sb a2, 4(t1)
    sb a3, 5(t1)
    sh a4, 6(t1)
    li a0, 0
ret
