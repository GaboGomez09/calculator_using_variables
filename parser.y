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
  typedef struct{
    int type; //1 = int, 2 = double and 3 = string
    union value{
        int ivalue;
        double dvalue;
        char* svalue;
    }value;
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
      | VAREXPR '\n'  {printf("\tresultado: %s\n", eliminate_last_char($1));}
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
                                    union value value;
                                    value.ivalue = $4;
                                    save_variable(first_substring($2) , 1,value, symbol_table);
                                    }
  | DOUBLE VARIABLE '=' DECEXPR ';' {
                                    union value value;
                                    value.dvalue = $4;
                                    save_variable(first_substring($2) , 2,value, symbol_table);
                                    }
  | STR VARIABLE '=' STREXPR ';'    {
                                    union value value;
                                    value.svalue = (char*)malloc(strlen($4));
                                    strcpy(value.svalue, $4);
                                    save_variable(first_substring($2) , 3,value, symbol_table);
                                    }
  |INT VARIABLE '=' DECEXPR ';'     {
                                    union value value;
                                    value.ivalue = (int)$4;
                                    save_variable(first_substring($2) , 1,value, symbol_table);
                                    }
  | DOUBLE VARIABLE '=' WHOLEXPR ';'{
                                    union value value;
                                    value.dvalue = (double)$4;
                                    save_variable(first_substring($2) , 2,value, symbol_table);
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
                        union value value;
                        value.ivalue = 0;
                        save_variable(first_substring($2) , 1,value, symbol_table);
                        }
  | DOUBLE VARIABLE ';' {
                        union value value;
                        value.dvalue = 0.0;
                        save_variable(first_substring($2) , 2,value, symbol_table);
                        }
  | STR VARIABLE ';'    {
                        union value value;
                        value.svalue = (char*)malloc(1);
                        value.svalue[0] = '\0';
                        save_variable(first_substring($2) , 3,value, symbol_table);
                        }
;

PRINTEXP: PRINT VARIABLE   {
                            Tuple *tuple = obtain_tuple($2, symbol_table);
                            if(tuple == NULL){
                              printf("\tError 404: Variable not found.\n");
                            }else{
                              switch(tuple->type){
                                case 1:
                                  printf("\t%s: %d\n", $2, tuple->value.ivalue);
                                  break;
                                case 2:
                                  printf("\t%s: %f\n", $2, tuple->value.dvalue);
                                  break;
                                case 3:
                                  printf("\t%s: %s\n", $2, tuple->value.svalue);
                                  break;
                              }
                            }
                           }
;

VAREXPR:  VARIABLE	{
                      Tuple *tuple = obtain_tuple(subtract_string(first_substring($1), "\n") , symbol_table);
                      if(tuple == NULL){
                        printf("\tError 404: Variable not found.\n");
                        $$[0] = '4';
                        $$[1] = '\0';
                      }else{
                        switch(tuple->type){
                          case 1:
                            sprintf($$, "%d", tuple->value.ivalue);
                            strcat($$, "1");
                            break;
                          case 2:
                            sprintf($$, "%0.7f", tuple->value.dvalue);
                            strcat($$, "2");
                            break;
                          case 3:
                            strcpy($$, tuple->value.svalue);
                            strcat($$, "3");
                            break;
                        }
                      }
                     }
| VAREXPR '+' VAREXPR        {
          $$ = (char*)malloc(15);
          strcpy($$, operation_solver(first_substring($1),subtract_string(first_substring($3), "\n"),'+'));
                              }
| VAREXPR '-' VAREXPR        {
          $$ = (char*)malloc(15);
          strcpy($$, operation_solver(first_substring($1),subtract_string(first_substring($3), "\n"),'-'));
                                }
| VAREXPR '*' VAREXPR        {
          $$ = (char*)malloc(15);
          strcpy($$, operation_solver(first_substring($1),subtract_string(first_substring($3), "\n"),'*'));
                                }
| VAREXPR '/' VAREXPR        {
          $$ = (char*)malloc(15);
          strcpy($$, operation_solver(first_substring($1),subtract_string(first_substring($3), "\n"),'/'));
                                }
| VAREXPR '+' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
          $$ = operation_solver(first_substring($1), num, '+');
                               }
| VAREXPR '-' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
          $$ = operation_solver(first_substring($1), num, '-');
                               }
| VAREXPR '*' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
          $$ = operation_solver(first_substring($1), num, '*');
                               }
| VAREXPR '/' WHOLEXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $3);
          strcat(num, "1");
          $$ = operation_solver(first_substring($1), num, '/');
                               }
| WHOLEXPR '+' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
          $$ = operation_solver(num , subtract_string(first_substring($1), "\n"), '+');
                              }
| WHOLEXPR '-' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
          $$ = operation_solver(num , subtract_string(first_substring($1), "\n"), '-');
}
| WHOLEXPR '*' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
          $$ = operation_solver(num , subtract_string(first_substring($1), "\n"), '*');
}
| WHOLEXPR '/' VAREXPR        {
          char* num = (char*)malloc(10);
          sprintf(num, "%d", $1);
          strcat(num, "1");
          $$ = operation_solver(num , subtract_string(first_substring($1), "\n"), '/');
}
| VAREXPR '+' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
          $$ = operation_solver(first_substring($1), num, '+');
                               }
| VAREXPR '-' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
          $$ = operation_solver(first_substring($1), num, '-');
                               }
| VAREXPR '*' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
          $$ = operation_solver(first_substring($1), num, '*');
                               }
| VAREXPR '/' DECEXPR        {
          char* num = (char*)malloc(15);
          sprintf(num, "%0.7f", $3);
          strcat(num, "2");
          $$ = operation_solver(first_substring($1), num, '/');
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
