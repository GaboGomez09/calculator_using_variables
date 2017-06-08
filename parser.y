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
      | VAREXPR '\n'  {printf("\tresultado: %s\n", subtract_string(subtract_string(subtract_string($1, "type1"), "type2"), "type3"));}
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
                      Tuple *tuple = obtain_tuple(subtract_string($1, "\n") , symbol_table);
                      if(tuple == NULL){
                        printf("\tError 404: Variable not found.\n");
                      }else{
                        switch(tuple->type){
                          case 1:
                            sprintf($$, "%d", tuple->value.ivalue);
                            strcat($$, "type1");
                            break;
                          case 2:
                            sprintf($$, "%0.7f", tuple->value.dvalue);
                            strcat($$, "type2");
                            break;
                          case 3:
                            strcpy($$, tuple->value.svalue);
                            strcat($$, "type3");
                            break;
                        }
                      }
                     }
| VAREXPR '+' VAREXPR        {
                                Tuple *tuple1 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($1, "type1"), "type2"), "type3"),"\n") , symbol_table);
                                Tuple *tuple2 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($3, "type1"), "type2"), "type3"),"\n") , symbol_table);

                                if(tuple1 == NULL || tuple2 == NULL){
                                  printf("\tError 404: Variable not found.\n");
                                }else{
                                  switch(tuple1->type){
                                    case 1:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%d", tuple1->value.ivalue + tuple2->value.ivalue);
                                          strcat($$, "type1");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue + tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 2:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue + tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", tuple1->value.dvalue + tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 3:
                                      switch(tuple2->type){
                                        case 1:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 2:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(strlen(tuple1->value.svalue)+strlen(tuple2->value.svalue));
                                          strcat($$,tuple1->value.svalue); strcat($$,tuple2->value.svalue);
                                          strcat($$, "type3");
                                          break;
                                      }
                                  }
                                }
                               }
| VAREXPR '-' VAREXPR        {
                                Tuple *tuple1 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($1, "type1"), "type2"), "type3"),"\n") , symbol_table);
                                Tuple *tuple2 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($3, "type1"), "type2"), "type3"),"\n") , symbol_table);

                                if(tuple1 == NULL || tuple2 == NULL){
                                  printf("\tError 404: Variable not found.\n");
                                }else{
                                  switch(tuple1->type){
                                    case 1:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%d", tuple1->value.ivalue - tuple2->value.ivalue);
                                          strcat($$, "type1");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue - tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 2:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue - tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", tuple1->value.dvalue - tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 3:
                                      switch(tuple2->type){
                                        case 1:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 2:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 3:
                                          $$ = subtract_string(tuple1->value.svalue, tuple2->value.svalue);
                                          strcat($$, "type3");
                                          break;
                                      }
                                  }
                                }
                               }
| VAREXPR '*' VAREXPR        {
                                Tuple *tuple1 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($1, "type1"), "type2"), "type3"),"\n") , symbol_table);
                                Tuple *tuple2 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($3, "type1"), "type2"), "type3"),"\n") , symbol_table);

                                if(tuple1 == NULL || tuple2 == NULL){
                                  printf("\tError 404: Variable not found.\n");
                                }else{
                                  switch(tuple1->type){
                                    case 1:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%d", tuple1->value.ivalue * tuple2->value.ivalue);
                                          strcat($$, "type1");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue * tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 2:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue * tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", tuple1->value.dvalue * tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 3:
                                      switch(tuple2->type){
                                        case 1:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 2:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                  }
                                }
                               }
| VAREXPR '/' VAREXPR        {
                                Tuple *tuple1 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($1, "type1"), "type2"), "type3"),"\n") , symbol_table);
                                Tuple *tuple2 = obtain_tuple(subtract_string(subtract_string(subtract_string(subtract_string($3, "type1"), "type2"), "type3"),"\n") , symbol_table);

                                if(tuple1 == NULL || tuple2 == NULL){
                                  printf("\tError 404: Variable not found.\n");
                                }else{
                                  switch(tuple1->type){
                                    case 1:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%d", tuple1->value.ivalue / tuple2->value.ivalue);
                                          strcat($$, "type1");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue / tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 2:
                                      switch(tuple2->type){
                                        case 1:
                                          sprintf($$, "%0.7f", (double)tuple1->value.ivalue / tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 2:
                                          sprintf($$, "%0.7f", tuple1->value.dvalue / tuple2->value.dvalue);
                                          strcat($$, "type2");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                    case 3:
                                      switch(tuple2->type){
                                        case 1:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 2:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                        case 3:
                                          $$ = (char*)malloc(sizeof(char)*6);
                                          strcat($$, "ERROR");
                                          printf("\tError: Tipos de datos incompatible\n");
                                          break;
                                      }
                                  }
                                }
                               }
| VAREXPR '+' WHOLEXPR        { }
| VAREXPR '-' WHOLEXPR        { }
| VAREXPR '*' WHOLEXPR        { }
| VAREXPR '/' WHOLEXPR        { }
| WHOLEXPR '+' VAREXPR        { }
| WHOLEXPR '-' VAREXPR        { }
| WHOLEXPR '*' VAREXPR        { }
| WHOLEXPR '/' VAREXPR        { }
| VAREXPR '+' DECEXPR        { }
| VAREXPR '-' DECEXPR        { }
| VAREXPR '*' DECEXPR        { }
| VAREXPR '/' DECEXPR        { }
| DECEXPR '+' VAREXPR        { }
| DECEXPR '-' VAREXPR        { }
| DECEXPR '*' VAREXPR        { }
| DECEXPR '/' VAREXPR        { }
| VAREXPR '+' STREXPR        { }
| VAREXPR '-' STREXPR        { }
| VAREXPR '*' STREXPR        { }
| VAREXPR '/' STREXPR        { }
| STREXPR '+' VAREXPR        { }
| STREXPR '-' VAREXPR        { }
| STREXPR '*' VAREXPR        { }
| STREXPR '/' VAREXPR        { }
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
