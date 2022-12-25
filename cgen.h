#include <stddef.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdarg.h>
#ifndef CGEN_H
#define CGEN_H


typedef struct sstream
{
	char *buffer;
	size_t bufsize;
	FILE* stream;
} sstream;

void ssopen(sstream* S);
char* ssvalue(sstream* S);
void ssclose(sstream* S);


/*
 	This function takes the same arguments as printf,
 	but returns a new string with the output value in it.
 */
char* template(const char* pat, ...);

void yyerror(char const* pat, ...);


extern int yyerror_count;


extern const char* c_prologue;

#endif
