
aux.s: aux.c
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax aux.c -S -o aux.s

aux.o: aux.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax aux.s -c -o aux.o

programa.x: aux.o 
	ld.lld aux.o 

all: programa.x
