                        /* Gabriel Gomez Tellez*/
                    /*Date of creation: June/3rd/2017*/

/*************************Declaration of libraries********************/
%{
#include <string.h>
#include <stdlib.h>
#include "parser.tab.h"
char* cadenaSinComillas(char* cadena){
	char* nuevaCadena = (char*)malloc(strlen(cadena));
	int contador = 0;

	while(cadena[contador+1] != '\0'){
		nuevaCadena[contador] = cadena[contador+1];
		contador++;
	}
	nuevaCadena[contador-1] = '\0';

	return nuevaCadena;
}
%}
/*************************Declaration of Lexemes********************/

WholeNumber -?[0-9]+
DecimalNumber -?[0-9]+"."[0-9]+
Variable _?[a-zA-Z][a-zA-Z0-9_]*
String \"[,.?¿!¡_:0-9a-zA-Z ]+\"

/*************************Rule definitions**************************/

%%
"string"          {
            printf("\treserved word: string\n");
            yylval.string = yytext;
            return (STR);
                  }

"double"            {
            printf("\treserved word: double\n");
            yylval.string = yytext;
            return (DOUBLE);
                    }

"int"               {
            printf("\treserved word: int\n");
            yylval.string = yytext;
            return (INT);
                  }

{WholeNumber}           {
    		          printf("\tWhole number %s\n",yytext);
                  yylval.whole = atoi(yytext);
                  return (WHOLE);
                        }

{DecimalNumber}          {
		printf("\tDecimal Number %s\n",yytext);
              sscanf(yytext, "%lf", &(yylval.decimal));
							return (DECIMAL);
              	}

{Variable}			{
		printf("\tVariable %s\n",yytext);
								yylval.string = yytext;
								return (VARIABLE);
								}

{String}						{
		printf("\tString %s\n",cadenaSinComillas(yytext));
							yylval.string = cadenaSinComillas(yytext);
							return (STRING);
								}

"+"	 	{
		printf("\tSigno mas\n");
                return (yytext[0]);
                }

"-"	 	{
		printf("\tSigno menos\n");
                return (yytext[0]);
                }

"*"	 	{
		printf("\tSigno producto\n");
		          return (yytext[0]);
          }

"/"	 	{
		printf("\tSigno division\n");
                return (yytext[0]);
                }

"\n"            {
		printf("\tSalto de linea\n");
                return (yytext[0]);
                }
";"           {
		printf("\tEnd of expressions symbol\n");
                return (yytext[0]);
                }
.               ;
%%
