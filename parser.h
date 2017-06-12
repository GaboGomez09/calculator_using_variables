#ifndef parser
#define parser

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "symbol_table.h"

#define TRUE 1
#define FALSE 0

char* first_substring(char* string){
  int first_string_length = 0;
  for (first_string_length = 0; first_string_length < strlen(string); first_string_length++) {
    if (isblank(string[first_string_length]) || isspace(string[first_string_length] || '\n')) {
      break;
    }
  }
  char* first_string = (char*)malloc(first_string_length);
  for (first_string_length = 0; first_string_length < strlen(string); first_string_length++) {
    if (isblank(string[first_string_length])) {
      break;
    }
    first_string[first_string_length] = string[first_string_length];

  }
  first_string[first_string_length+1] = '\0';

  return first_string;

}

int variable_exists(char* variable_name, Symbol_Table *st){
  Tuple *pointer = st->head;
  while (pointer) {
    if (!strcmp(variable_name, pointer->name)) {
      return TRUE;
    }
    pointer = pointer->next;
  }
  return FALSE;
}

void save_variable(char* variable_name ,int type,union value value, Symbol_Table *st){
  if (variable_exists(variable_name, st)) {
    printf("\t%s\n", "Error: Variable already exists");
  }else{
    Tuple* new_tuple = create_tuple(variable_name, type, value);
    insert_tuple(st, new_tuple);
  }
}


char* subtract_string(char* string1, char* string2)
{
  int counter, counter2, match, start, found_string = 0;
  /*
      The first part of this function checks if string2 is contained
      in string1, it does this by counting how many characters
      match after its first encounter. It only subtracts the
      first instance found.
  */
  for (counter = 0; counter < strlen(string1); counter++)
  {
    counter2 = 0;
    /*
        The first if assures that it has found matching character
        and that it won't give a null pointer error.
    */
    if ((string1)[counter] == string2[counter2]
    && strlen(string1)-counter >= strlen(string2))
    {
      match = 0;
      for (counter2 = 0; counter2 < strlen(string2); counter2++)
      {
        if ((string1)[counter+counter2] == string2[counter2])
        {
          match++;
        }
      }
      /*
        After finishing iterating the next step is to know if it could
        find string2 inside of string1, this is known if match is equal
        to the length of string2.
      */
      if (match == strlen(string2)) {
        //It saves the position where it encountered the first character.
        start = counter;
        //Flag to notify that the string has been found.
        found_string = 1;
      }
      //In the case that this is not true the function does nothing and
      //it keeps searching.
    }
  }
  /*
      In the case that it string2 is a substring of string1 it will
      iterate through string1 copying all the characters to a new char*
      except the substring.
  */
  if (found_string)
  {
    counter2 = 0;
    char* subtracted_string = (char*)malloc(strlen(string1)-strlen(string2)+1);
    for (counter = 0; counter < strlen(string1); counter++)
    {
      if (counter == start)
      {
        counter += strlen(string2);
      }
      subtracted_string[counter2] = string1[counter];
      counter2++;
    }
    subtracted_string[counter2+1] = '\0';
    return subtracted_string;
  }else{
    return string1;
  }
}

char* eliminate_last_char(char* string){
  string[strlen(string)-1] = '\0';
  return string;
}

char* operation_solver(char* first_expression, char* second expression, char operation){
    int a,b;
    double c,d;
    char* expression_result;
    switch(first_expression[strlen(first_expression)-1]){
      case '1':
        switch(second_expression[strlen(second_expression)-1]){
          case '1':
            switch (operation) {
              case '+':
                a = atoi(eliminate_last_char(first_expression));
                b = atoi(eliminate_last_char(second_expression));
                sprintf(expression_result, "%d", a + b);
                strcat(expression_result, "1");
                break;
              case '-':
                a = atoi(eliminate_last_char(first_expression));
                b = atoi(eliminate_last_char(second_expression));
                sprintf(expression_result, "%d", a - b);
                strcat(expression_result, "1");
                break;
              case '/':
                a = atoi(eliminate_last_char(first_expression));
                b = atoi(eliminate_last_char(second_expression));
                sprintf(expression_result, "%d", a / b);
                strcat(expression_result, "1");
                break;
              case '*':
                a = atoi(eliminate_last_char(first_expression));
                b = atoi(eliminate_last_char(second_expression));
                sprintf(expression_result, "%d", a * b);
                strcat(expression_result, "1");
                break;
            }
            break;
          case '2':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '3':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '4':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
        }
        break;
      case '2':
        switch(second_expression[strlen(second_expression)-1]){
          case '1':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '2':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '3':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '4':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
        }
        break;
      case '3':
        switch(second_expression[strlen(second_expression)-1]){
          case '1':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '2':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '3':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '4':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
        }
        break;
      case '4':
        switch(second_expression[strlen(second_expression)-1]){
          case '1':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '2':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '3':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
          case '4':
            switch (operation) {
              case '+':
                break;
              case '-':
                break;
              case '/':
                break;
              case '*':
                break;
            }
            break;
        }
        break;
    }
}

#endif
