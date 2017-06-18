                    /* Gabriel Gomez Tellez*/
                /*Date of creation: June/4th/2017*/

/**********************************************************************/
/**************************Declaration of Libraries********************/
/**********************************************************************/
%{
#include "parser.h"
Symbol_Table *symbol_table;
%}

/**********************************************************************/
/*************************Declaration of Data Types********************/
/**********************************************************************/
%union{
  int whole;
  double decimal;
  char* string;
  struct flex_type{
    int type; //1 = int, 2 = double and 3 = string
    union value_returned{
        int ivalue;
        double dvalue;
        char* svalue;
    }value_returned;
  }flex_type; //short for flexible type
}

/**********************************************************************/
/************************Declaration of Terminals**********************/
/**********************************************************************/
%token <whole> WHOLE
%token <decimal> DECIMAL
%token <string> STRING
%token <string> VARIABLE
%token PRINT
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
%type <string> PRINTEXP
%type <string> VAREXPR
%left '+' '-'
%left '*' '/'

/**********************************************************************/
/*********************************GRAMMAR******************************/
/**********************************************************************/
%%

input:    /* empty string */
      | input line {}
;

line:     '\n'
      | WHOLEXPR '\n'  { printf ("\t\tresultado: %d\n", $1); }
      | DECEXPR '\n'  { printf ("\t\tresultado: %f\n", $1); }
      | STREXPR '\n'  { printf ("\t\tresultado: %s\n", $1); }
      | VAREXPR '\n'  {}
      | INIT  '\n'  {}
      | DCLR  '\n'  {}
      | ASSIGN '\n' {}
      | PRINTEXP '\n' {}
;

ASSIGN: VARIABLE '=' WHOLEXPR ';' {}
    | VARIABLE '=' DECEXPR ';'{}
    | VARIABLE '=' STREXPR ';' {printf("\t$1: %s, $3: %s\n", $1, $3);}
;

INIT: INT VARIABLE '=' WHOLEXPR ';' {

                                    }
  | DOUBLE VARIABLE '=' DECEXPR ';' {

                                    }
  | STR VARIABLE '=' STREXPR ';'    {

                                    }
  |INT VARIABLE '=' DECEXPR ';'     {

                                    }
  | DOUBLE VARIABLE '=' WHOLEXPR ';'{

                                    }
  | STR VARIABLE '=' DECEXPR ';'    {
                                    printf("\tError: Tipos de datos incompatible\n");
                                    }
  |INT VARIABLE '=' STREXPR ';'     {
                                    printf("\tError: Tipos de datos incompatible\n");
                                    }
  | DOUBLE VARIABLE '=' STREXPR ';' {
                                    printf("\tError: Tipos de datos incompatible\n");
                                    }
  | STR VARIABLE '=' WHOLEXPR ';'   {
                                    printf("\tError: Tipos de datos incompatible\n");
                                    }
;


DCLR: INT VARIABLE ';'  {

                        }
  | DOUBLE VARIABLE ';' {

                        }
  | STR VARIABLE ';'    {
                        }
;

PRINTEXP: PRINT VARIABLE   {

                           }
;

VAREXPR:  VARIABLE	{

                     }
| VAREXPR '+' VAREXPR        {
          $$ = (char*)malloc(15);
                              }
| VAREXPR '-' VAREXPR        {
          $$ = (char*)malloc(15);
                                }
| VAREXPR '*' VAREXPR        {
          $$ = (char*)malloc(15);
                                }
| VAREXPR '/' VAREXPR        {
          $$ = (char*)malloc(15);
                                }
| VAREXPR '+' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
                               }
| VAREXPR '-' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
                               }
| VAREXPR '*' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
                               }
| VAREXPR '/' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
                               }
| WHOLEXPR '+' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
                              }
| WHOLEXPR '-' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
}
| WHOLEXPR '*' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
}
| WHOLEXPR '/' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
}
| VAREXPR '+' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
                               }
| VAREXPR '-' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
                               }
| VAREXPR '*' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
                               }
| VAREXPR '/' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
                               }
| DECEXPR '+' VAREXPR        { }
| DECEXPR '-' VAREXPR        { }
| DECEXPR '*' VAREXPR        { }
| DECEXPR '/' VAREXPR        { }
| VAREXPR '+' STREXPR        {

                               }
| VAREXPR '-' STREXPR        {

                               }
| VAREXPR '*' STREXPR        {

                               }
| VAREXPR '/' STREXPR        {

                               }
| STREXPR '+' VAREXPR        {

                               }
| STREXPR '-' VAREXPR        {

                               }
| STREXPR '*' VAREXPR        {

                               }
| STREXPR '/' VAREXPR        {

                               }
| '-' VAREXPR {}
;

WHOLEXPR:     WHOLE	{ $$ = $1; }
| WHOLEXPR '+' WHOLEXPR        { $$ = $1 + $3;}
| WHOLEXPR '-' WHOLEXPR        { $$ = $1 - $3;}
| WHOLEXPR '*' WHOLEXPR        { $$ = $1 * $3;}
| WHOLEXPR '/' WHOLEXPR        { $$ = $1 / $3;}
| '-' WHOLEXPR { $$ = -1*$2;}
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
| '-' DECEXPR { $$ = -1*$2;}
;

STREXPR:     STRING	{ $$ = (char*)malloc(strlen($1));strcat($$,$1); }
| STREXPR '+' STREXPR  {
                        $$ = (char*)malloc(strlen($1)+strlen($3));
                        strcat($$,$1); strcat($$,$3);
                         }
| STREXPR '-' STREXPR {
                        $$ = subtract_string($1,$3);
}
;



%%

int main() {
symbol_table = (Symbol_Table*)malloc(sizeof(Symbol_Table));
symbol_table->head = NULL;
symbol_table->length = 0;
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
