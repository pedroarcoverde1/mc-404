calculadora.s: calculadora.c
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax calculadora.c -S -o calculadora.s

calculadora.o: calculadora.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax calculadora.s -c -o calculadora.o

start.s: start.c
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax start.c -S -o start.s

start.o: start.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax start.s -c -o start.o

programa.x: calculadora.o start.o
	ld.lld calculadora.o start.o -o programa.x

all: programa.x

file.o: file.c
	gcc -c file.o file.c

file: file.o
	gcc -o file file.o
