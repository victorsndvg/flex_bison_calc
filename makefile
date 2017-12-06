calculadora: calculadora.l calculadora.y
	bison -d calculadora.y
	flex calculadora.l
	gcc -I. -g -o calculadora dictionary.c calculadora.tab.c lex.yy.c -lfl -lm

clean:
	rm calculadora calculadora.tab.h calculadora.tab.c lex.yy.c
