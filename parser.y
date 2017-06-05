                      /* Gabriel Gomez Tellez*/
                  /*Date of creation: June/4th/2017*/

/**********************************************************************/
/**************************Declaration of Libraries********************/
/**********************************************************************/
%{
#include "parser.h"
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
%type <whole> expENT
%type <decimal> expRE
%type <string> expTXT

%left '+' '-'
%left '*' '/'

/**********************************************************************/
/*********************************GRAMMAR******************************/
/**********************************************************************/
%%

input:    /* empty string */
        | input line
;

line:     '\n'
        | expENT '\n'  { printf ("\t\tresultado: %d\n", $1); }
        | expRE '\n'  { printf ("\t\tresultado: %f\n", $1); }
        | expTXT '\n'  { printf ("\t\tresultado: %s\n", $1); }
        | INIT  '\n'  {}
        | DCLR  '\n'  {}
;

INIT: INT VARIABLE '=' WHOLE ';' {}
    | DOUBLE VARIABLE '=' DECIMAL ';'{}
    | STR VARIABLE '=' STRING ';' {}
;


DCLR: INT VARIABLE ';' {printf("\tthis is a declaration \n");}
    | DOUBLE VARIABLE ';' {}
    | STR VARIABLE ';' {}
;

expENT:     WHOLE	{ $$ = $1; }
	| expENT '+' expENT        { $$ = $1 + $3;}
  | expENT '-' expENT        { $$ = $1 - $3;}
  | expENT '*' expENT        { $$ = $1 * $3;}
  | expENT '/' expENT        { $$ = $1 / $3;}
  |'-' expENT { $$ = -1*$2;}
;

expRE:     DECIMAL	{ $$ = $1; }
  | expRE '+' expENT        { $$ = $1 + (float)$3;}
  | expRE '-' expENT        { $$ = $1 - (float)$3;}
  | expRE '*' expENT        { $$ = $1 * (float)$3;}
  | expRE '/' expENT        { $$ = $1 / (float)$3;}
  | expENT '+' expRE        { $$ = (float)$1 + $3;}
  | expENT '-' expRE        { $$ = (float)$1 - $3;}
  | expENT '*' expRE        { $$ = (float)$1 * $3;}
  | expENT '/' expRE        { $$ = (float)$1 / $3;}
  | expRE '+' expRE        { $$ = $1 + $3;}
  | expRE '-' expRE        { $$ = $1 - $3;}
  | expRE '*' expRE        { $$ = $1 * $3;}
  | expRE '/' expRE       { $$ = $1 / $3;}
	|'-' expRE { $$ = -1*$2;}

;

expTXT:     STRING	{ $$ = (char*)malloc(strlen($1));strcat($$,$1); }
	| expTXT '+' expTXT  {
                          $$ = (char*)malloc(strlen($1)+strlen($3));
                          strcat($$,$1); strcat($$,$3);    }
	| expTXT '-' expTXT {
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
