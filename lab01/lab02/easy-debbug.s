/*
 paleta de comando de debbug

symbols : mostra o endereço dos simbolos (_start, loop, end, result) (formato hexadecimal)
until <endereço>: executa as instruções até o endereço dado
step <n>: executa n instruções
peek r <register>: mostra o valor armazenado nos registradores (peek r all ->mostra tudo)
peek m <endereço>: mostra o valor armazenado na palavra de memória
poke r <registrador><valor> : modifica o valor do resgistrador pelo novo (poke r x1 0xff stores the value 0xff in register x1)
run: executa tudo
* */






.globl _start

_start:
  li x11, 21          # loads the value 21 into register x11
  li x12, 21          # loads the value 21 into register x12
  add x10, x11, x12   # adds the contents of registers x11 and x12 and 
                      # stores the result in register x10
  li a7, 93           # loads the value 93 into register a7
  ecall               # generates a software interrupt

