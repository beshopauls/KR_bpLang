%{
  #include <stdio.h>
  #include "cgen.h"
  
  extern int yylex(void);
  extern int lineNum;
%}

%union
{
	char* str;
  int num;
}

%define parse.trace
%debug
   
%token KW_RETURN
 %token KW_INTEGER
  %token  KW_STRING
 %token  KW_FOR
 %token  KW_CHAR
%token   KW_VOID
%token  KW_
%token   KW_REAL
%token KW_END
%token  KW_BEGIN
 %token <str> KW_SEMICLN
 %token COMMA
 %token  OPEN_HK
 %token CLOSE_HK
%token <str> STRINGS
%token <str>  CHARACTER
%token <str> IDENTIFIERS
%token <str> INTEGERS
%token <str> FLOATS
 %token <str> RD_STR
%token <str> RD_INT
 %token <str> RD_REAL
 %token <str> WR_STR
%token <str> WR_INT
 %token <str> WR_REAL
%token  CLN
%token KW_MAIN
/* for expresion*/
%right KW_PLUS
%right	KW_SUB
%left	KW_MUL
%left KW_DIV
%left KW_MOD
%left KW_GREATEREQUAL
%left KW_LESSEQUAL
%left KW_GREATHAN
%left KW_LESSTHAN
%left KW_INEQ
%left EQUAL
%start header_jobs
%type <str> instr
%type <str> header
%type <str> header_jobs
%type <str> expr
%type <str> erotimatiko
%type <str> type
%type <str> declarations 
%type <str> list_var
%type <str> give_value
%type <str>  type_of_values
%type <str> Declare_Arrays
%type <str> functions_declaration
%type <str> function_parameters
%type  <str> external_declaration
%type <str> code
%type <str> cmd
%type <str> simple_instructions
%type <str> assign_cmd
%type <str> programm
%type <str> complex_instractions
%type <str>for_stmt
%type <str> ci
%type <str> call_function_parameters 
%type <str> call_function 
%type <str> Declare_Arrays_expr
 %token  OPEN_PAR
 %token CLOSE_PAR
%right UMINUS
%right UPLUS
%left  MINUS
%left  PLUS
//%right CAST
%left  FACTOR
%left  RELATION
%right PAR_R
%%
programm: 
 external_declaration			{ $$ = template("%s\n", $1);}
| programm external_declaration { $$ = template("%s %s\n",$1,$2);}
;
header : {
{ 
$$ = template("/*Flogothetis Programms*/ \n #include <stdio.h>\n#include <stdlib.h>\n#include<string.h>\nvoid writeString(char *str) { printf( \" \\n%%s \" ,str); }\n void readString(char* x){ scanf(\"%%s\",x);}\n int readInteger(){int x; scanf(\"%%d\",&x);return x;}\n float readReal(){float x;scanf(\"%%f\",&x);return x;} \n void writeInteger(int i){printf(\" \%%d  \",i);}\n void writeReal(float r){printf(\"\\n%%f\",r);} \n\n");}
}
;
external_declaration:
	functions_declaration	{ $$ = template("%s", $1);}
	| declarations			{ $$ = template("%s", $1);}
	;
header_jobs :  
header programm KW_MAIN OPEN_PAR CLOSE_PAR KW_BEGIN code KW_END {printf("%s %s\n int main()\n{%s\n}",$1,$2,$7);}
|header KW_MAIN OPEN_PAR CLOSE_PAR KW_BEGIN code KW_END {printf("%s\nint main()\n{%s\n}",$1,$6);}
;
functions_declaration: 
type   IDENTIFIERS OPEN_PAR function_parameters CLOSE_PAR KW_BEGIN code KW_END {$$ = template("%s %s(%s)\n{\n%s}",$1,$2,$4,$7);}
|type IDENTIFIERS OPEN_PAR CLOSE_PAR KW_BEGIN code KW_END  {$$ = template("%s %s()\n{\n%s}",$1,$2,$6);}
;
code:
instr			{ $$ = template("%s\n", $1);}
|code instr		{ $$ = template("%s %s\n",$1,$2);}
;
instr:
assign_cmd  erotimatiko { $$ = template("\n%s;",$1); } 
|erotimatiko { $$ = template(";\n"); }
|declarations   { $$ = template("%s\n",$1); } 
|KW_RETURN expr erotimatiko { $$ = template("return %s;\n",$2); } 
|KW_BEGIN ci KW_END{ $$ = template("{\n%s}",$2); } 
|call_function erotimatiko { $$ = template("%s;\n",$1); } 
|cmd
;
cmd:
for_stmt { $$ = template("%s",$1); } 
;
for_stmt: 
KW_FOR OPEN_PAR assign_cmd erotimatiko expr erotimatiko assign_cmd CLOSE_PAR  simple_instructions {$$ = template("for(%s;%s;%s)\n%s ", $3, $5,$7,$9);}
;
simple_instructions : 
 cmd  	   { $$ = template("%s",$1); } 
| assign_cmd  erotimatiko { $$ = template("\n%s;",$1); } 
|erotimatiko { $$ = template(";\n"); }
|declarations   { $$ = template("%s\n",$1); } 
|KW_RETURN expr erotimatiko { $$ = template("return %s;\n",$2); } 

|KW_BEGIN ci KW_END{ $$ = template("{\n%s}",$2); } 
|call_function erotimatiko { $$ = template("%s;\n",$1); } 
;
ci:
complex_instractions { $$ = template("%s",$1); } 
|ci complex_instractions {$$ = template("%s%s",$1,$2); }
;
complex_instractions:
cmd { $$ = template("%s\n",$1); } 
| assign_cmd  erotimatiko  { $$ = template("%s;\n",$1); } 
|KW_RETURN expr erotimatiko { $$ = template("return %s;\n",$2); } 
|erotimatiko { $$ = template(";\n"); }
|declarations   { $$ = template("%s\n",$1); } 
|KW_BEGIN complex_instractions KW_END { $$ = template("{\n%s\n}",$2); }
|call_function erotimatiko { $$ = template("%s;\n",$1); } 
;
;
call_function :
IDENTIFIERS OPEN_PAR call_function_parameters CLOSE_PAR  {$$ = template("%s(%s)",$1,$3);}
|IDENTIFIERS OPEN_PAR CLOSE_PAR  {$$ = template("%s()",$1);}
assign_cmd : 
IDENTIFIERS CLN EQUAL expr   { $$ = template("%s=%s",$1,$4); } 
|type_of_values IDENTIFIERS CLN EQUAL expr   { $$ = template("%s %s=%s",$1,$2,$5); } 
|IDENTIFIERS Declare_Arrays CLN EQUAL expr { $$ = template("%s%s=%s", $1,$2,$5);}
;
function_parameters:
type IDENTIFIERS { $$ = template("%s %s", $1,$2);}
|function_parameters COMMA type IDENTIFIERS  { $$ = template("%s,%s %s  ", $1,$3,$4);}
;
call_function_parameters :
expr { $$ = template("%s", $1);}
|call_function_parameters COMMA  IDENTIFIERS  { $$ = template("%s,%s ", $1,$3);}
;
declarations:
type list_var erotimatiko { $$ = template("%s %s  ;", $1,$2);}
;
list_var:
IDENTIFIERS give_value  { $$ = template("%s%s", $1,$2);}
|IDENTIFIERS  { $$ = template("%s", $1);}
|list_var COMMA IDENTIFIERS give_value   { $$ = template("%s,%s%s  ", $1,$3,$4);}
|list_var COMMA IDENTIFIERS   { $$ = template("%s,%s  ", $1,$3);}
|list_var COMMA IDENTIFIERS Declare_Arrays  { $$ = template("%s,%s%s ", $1,$3,$4);}
|IDENTIFIERS Declare_Arrays { $$ = template("%s%s", $1,$2);}
;
Declare_Arrays:
OPEN_HK expr CLOSE_HK { $$ = template("[%s]", $2);}
|Declare_Arrays OPEN_HK expr CLOSE_HK { $$ = template("%s[%s]", $1,$3);}
;
Declare_Arrays_expr:
IDENTIFIERS Declare_Arrays { $$ = template("%s%s", $1,$2);}
give_value:
CLN EQUAL type_of_values { $$ = template("=%s",$3); }
;
type_of_values:
expr;
type:
KW_INTEGER	{ $$ = template("int"); }
|KW_CHAR 	{ $$ = template("char"); }
|KW_REAL 	{ $$ = template("float"); }
|KW_STRING	{ $$ = template("string"); }
|KW_VOID	{ $$ = template("void"); }
;
erotimatiko:
KW_SEMICLN
;
expr:
INTEGERS 
|FLOATS
|STRINGS
|CHARACTER
|IDENTIFIERS
|call_function
|Declare_Arrays_expr
| OPEN_PAR expr CLOSE_PAR 	%prec PAR_R	{ $$ = template("(%s)", $2); }
| expr KW_PLUS expr 	%prec PLUS				{ $$ = template("%s+%s",$1,$3); }
| KW_SUB expr          {$$ = template("-(%s)", $2);}
| KW_PLUS expr  %prec UPLUS         {$$ = template("+(%s)", $2);}
| expr KW_SUB expr  %prec MINUS      {$$ = template("%s - %s", $1, $3);}
| expr KW_MUL expr      {$$ = template("%s * %s", $1, $3);}
| expr KW_MOD expr        {$$ = template("%s %% %s", $1, $3);}
| expr KW_DIV expr     {$$ = template("%s / %s", $1, $3);}
| expr EQUAL expr        {$$ = template("%s == %s", $1, $3);}
| expr KW_LESSTHAN expr     {$$ = template("%s < %s", $1, $3);}
| expr KW_GREATHAN expr     {$$ = template("%s > %s", $1, $3);}
| expr KW_LESSEQUAL expr   {$$ = template("%s <= %s", $1, $3);}
| expr KW_GREATEREQUAL expr   {$$ = template("%s >= %s", $1, $3);}
%%

int main () {
  yyparse() ;
}