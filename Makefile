build:
	bison -d -v -r all myparser.y
	flex mylexer.l
clean:
	rm -rf lex.yy.c mycomp myparser.output myparser.tab.c myparser.tab.h tests/*.c main.out
helloworld:
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < tests/HelloWorld.bp > tests/HelloWorld.c
	gcc tests/HelloWorld.c -o main.out  
	./main.out
array:
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < tests/Array.bp > tests/Array.c
	gcc tests/Array.c -o main.out  
	./main.out
function:
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < tests/Function.bp > tests/Function.c
	gcc tests/Function.c -o main.out  
	./main.out

