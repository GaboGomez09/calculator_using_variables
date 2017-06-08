/* Gabriel Gomez Tellez*/
                /*Date of creation: June/4th/2017*/

/**********************************************************************/
/**************************Declaration of Libraries********************/
/**********************************************************************/
%{
#include "parser.h"
Symbol_Table symbol_table = (Symbol_Table*)malloc(sizeof(Symbol_Table));
symbol_table->next = NULL;
symbol_table->length = 0;
%}

/**********************************************************************/
/*************************Declaration of Data Types********************/
/**********************************************************************/
%union{
int whole;
double decimal;
char* string;
}

/**********************************************************************/
/************************Declaration of Terminals**********************/
/**********************************************************************/
%token <whole> WHOLE
%token <decimal> DECIMAL
%token <string> STRING
%token <string> VARIABLE
%token INT
%token DOUBLE
%token STR
/**********************************************************************/
/*********************Declaration of Non-Terminals*********************/
/**********************************************************************/
%type <string> INIT
%type <string> DCLR
%type <string> ASSIGN
%type <whole> WHOLEXPR
%type <decimal> DECEXPR
%type <string> STREXPR

%left '+' '-'
%left '*' '/'

/**********************************************************************/
/*********************************GRAMMAR******************************/
/**********************************************************************/
%%

input:    /* empty string */
      | input line {printf("this did something");}
;

line:     '\n'
      | WHOLEXPR '\n'  { printf ("\t\tresultado: %d\n", $1); }
      | DECEXPR '\n'  { printf ("\t\tresultado: %f\n", $1); }
      | STREXPR '\n'  { printf ("\t\tresultado: %s\n", $1); }
      | INIT  '\n'  {}
      | DCLR  '\n'  {}
      | ASSIGN '\n' {}
;

ASSIGN: VARIABLE '=' WHOLEXPR ';' {}
    | VARIABLE '=' DECEXPR ';'{}
    | VARIABLE '=' STREXPR ';' {printf("\t$1: %s, $3: %s\n", $1, $3);}
;

INIT: INT VARIABLE '=' WHOLEXPR ';' {}
  | DOUBLE VARIABLE '=' DECEXPR ';'{}
  | STR VARIABLE '=' STREXPR ';' {}
;


DCLR: INT VARIABLE ';' {}//union value value;
                      //value.ivalue = 0;
        //save_variable(first_substring(name($2)) ,type(1),value);}
  | DOUBLE VARIABLE ';' {}
  | STR VARIABLE ';' {}
;

WHOLEXPR:     WHOLE	{ $$ = $1; }
| WHOLEXPR '+' WHOLEXPR        { $$ = $1 + $3;}
| WHOLEXPR '-' WHOLEXPR        { $$ = $1 - $3;}
| WHOLEXPR '*' WHOLEXPR        { $$ = $1 * $3;}
| WHOLEXPR '/' WHOLEXPR        { $$ = $1 / $3;}
|'-' WHOLEXPR { $$ = -1*$2;}
;

DECEXPR:     DECIMAL	{ $$ = $1; }
| DECEXPR '+' WHOLEXPR        { $$ = $1 + (float)$3;}
| DECEXPR '-' WHOLEXPR        { $$ = $1 - (float)$3;}
| DECEXPR '*' WHOLEXPR        { $$ = $1 * (float)$3;}
| DECEXPR '/' WHOLEXPR        { $$ = $1 / (float)$3;}
| WHOLEXPR '+' DECEXPR        { $$ = (float)$1 + $3;}
| WHOLEXPR '-' DECEXPR        { $$ = (float)$1 - $3;}
| WHOLEXPR '*' DECEXPR        { $$ = (float)$1 * $3;}
| WHOLEXPR '/' DECEXPR        { $$ = (float)$1 / $3;}
| DECEXPR '+' DECEXPR        { $$ = $1 + $3;}
| DECEXPR '-' DECEXPR        { $$ = $1 - $3;}
| DECEXPR '*' DECEXPR        { $$ = $1 * $3;}
| DECEXPR '/' DECEXPR       { $$ = $1 / $3;}
|'-' DECEXPR { $$ = -1*$2;}

;

STREXPR:     STRING	{ $$ = (char*)malloc(strlen($1));strcat($$,$1); }
| STREXPR '+' STREXPR  {
                        $$ = (char*)malloc(strlen($1)+strlen($3));
                        strcat($$,$1); strcat($$,$3);
                        printf("\t$1: %s, $3: %s\n", $1, $3);    }
| STREXPR '-' STREXPR {
                        $$ = subtract_string($1,$3);
}
;



%%

int main() {

yyparse();
}

yyerror (char *s)
{
printf ("--%s--\n", s);
}

int yywrap()
{
return 1;
}
