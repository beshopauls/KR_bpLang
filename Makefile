build:
	bison -d -v -r all myparser.y
	flex mylexer.l
clean:
	rm -rf lex.yy.c mycomp myparser.output myparser.tab.c myparser.tab.h tests/*.c main.out
helloworld:
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < HelloWorld.bp > HelloWorld.c
	gcc HelloWorld.c -o main.out  
	./main.out
array:
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < Array.bp > Array.c
	gcc Array.c -o main.out  
	./main.out
function:
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < Function.bp > Function.c
	gcc Function.c -o main.out  
	./main.out

