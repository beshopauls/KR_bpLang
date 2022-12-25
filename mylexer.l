%{
  #include <stdio.h>
  #include <string.h>  
  #include "cgen.h"
  #include  "myparser.tab.h"
  
  int lineNum = 1;
%}
/* definitions */
%x C_COMMENT
Identifiers [A-Za-z][A-Za-z0-9_]*
Integers [0-9][0-9]*
Digit [0-9]
Floats {Integers}("."{Digit}+)?([eE][+-]?{Integers})?
Non_print [^"\\"^"\'"^"\""^"\n"]
Escape_Sequence  ("\\n"|"\\t"|"\\r"|"\\\\"|"\\\'"|"\\\"")
Constant_Character ("\'")(({Escape_Sequence}|{Non_print}))("\'")
Constant_strings("\"")(({Escape_Sequence}|{Non_print})*)("\"")
Arithmetic_Operators    ("+"|"-"|"*"|"/"|"mod")
Relational_Operators    ("="|">="|"<=")
Logical_operators 		(">"|"<")
Logical_negative 		["!"]
/* rules */
%%
"/*"            { BEGIN(C_COMMENT); }
<C_COMMENT>"*/" { BEGIN(INITIAL); }
<C_COMMENT>\n   { }
<C_COMMENT>.    { }
"//"[^\n]*  /* eat line comments */
"integer main" { yylval.str = strdup(yytext); return KW_MAIN;}
integer	{ yylval.str = strdup(yytext); return KW_INTEGER;}
string	{ yylval.str = strdup(yytext); return KW_STRING;}
for		{ yylval.str = strdup(yytext); return KW_FOR;}
character	{ yylval.str = strdup(yytext); return KW_CHAR;}
void	{ yylval.str = strdup(yytext); return KW_VOID;}
return	{ yylval.str = strdup(yytext); return KW_RETURN;}
end		{ yylval.str = strdup(yytext); return KW_END;}
mod		{ yylval.str = strdup(yytext); return KW_MOD;}
real	{ yylval.str = strdup(yytext); return KW_REAL;}
begin	{ yylval.str = strdup(yytext); return KW_BEGIN;}
"+"		{ yylval.str = strdup(yytext); return KW_PLUS;}
"-"		{ yylval.str = strdup(yytext); return KW_SUB;}
"*"		{ yylval.str = strdup(yytext); return KW_MUL;}
"/"		{ yylval.str = strdup(yytext); return KW_DIV;}
">="	{ yylval.str = strdup(yytext); return KW_GREATEREQUAL;}
"<="	{ yylval.str = strdup(yytext); return KW_LESSEQUAL;}
">"		{ yylval.str = strdup(yytext); return KW_GREATHAN;}
"<"		{ yylval.str = strdup(yytext); return KW_LESSTHAN;}
";"		{ yylval.str = strdup(yytext); return KW_SEMICLN;}
"("		{ yylval.str = strdup(yytext); return OPEN_PAR;}
")"		{ yylval.str = strdup(yytext); return CLOSE_PAR;}
","       { yylval.str = strdup(yytext); return COMMA;}
"["       { yylval.str = strdup(yytext); return OPEN_HK;}
"]"       { yylval.str = strdup(yytext); return CLOSE_HK;}
":"	               		{ yylval.str = strdup(yytext);return CLN;}
"="	                	{ yylval.str = strdup(yytext);return EQUAL;}
{Constant_strings} 		{ yylval.str = strdup(yytext); return STRINGS;}
{Constant_Character} 	{ yylval.str = strdup(yytext); return CHARACTER;}
{Identifiers} 			{ yylval.str = strdup(yytext); return IDENTIFIERS;}
{Integers}    			{ yylval.str = strdup(yytext); return INTEGERS;}
{Floats}      			{ yylval.str = strdup(yytext); return FLOATS;}
\n 					 lineNum++;
