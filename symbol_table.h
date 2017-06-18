#ifndef symbol_table_h
#define symbol_table_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Tuple{
    char* name;
    int type; //1 = int, 2 = double and 3 = string
    union value{
        int ivalue;
        double dvalue;
        char* svalue;
    }value;
    struct Tuple* next;
}Tuple;


typedef struct Symbol_Table{
  Tuple* head;
  int length;
}Symbol_Table;

Tuple* create_tuple(char* name ,int type ,union value value){
  Tuple* tuple = (Tuple*)malloc(sizeof(Tuple));
  tuple->name = (char*)malloc(20);
  strcpy(tuple->name, name);
  tuple->type = type;
  tuple->next = NULL;
  switch (type) {
    case 1:
      tuple->value.ivalue = value.ivalue;
      break;
    case 2:
      tuple->value.dvalue = value.dvalue;
      break;
    case 3:
      tuple->value.svalue = (char*)malloc(strlen(value.svalue));
      strcpy(tuple->value.svalue,value.svalue);
      break;
    default:
      printf("%s\n", "Invalid type.\n");
      break;
  }
  return tuple;
}


void insert_tuple(Symbol_Table *st, Tuple *tuple){
  if (st->head == NULL) {
    st->head = tuple;
  }else{
    Tuple *pointer = st->head;
    while (pointer->next) {
      pointer = pointer->next;
    }
    pointer->next = tuple;
  }
  st->length++;
}

Tuple* obtain_tuple(char* var, Symbol_Table *st){
  if (st->head == NULL) {
    return NULL;
  }else{
    Tuple* pointer = st->head;
    while (pointer) {
      if (!strcmp(var, pointer->name)) {
        return pointer;
      }
      pointer = pointer->next;
    }
    return NULL;
  }
}
char* eliminate_last_char(char* string){
  string[strlen(string)-1] = '\0';
  return string;
}
int change_value(char* var, char *value, Symbol_Table *st){
  if (st->head == NULL) {
    return 0;
  }else{
    Tuple* pointer = st->head;
    while (pointer) {
      if (!strcmp(var, pointer->name)) {
        switch (pointer->type) {
          case 1:
            switch (value[strlen(value)-1]) {
              case '1':
                pointer->value.ivalue = atoi(eliminate_last_char(value));
                return 1;
                break;
              case '2':
                pointer->value.ivalue = (int)atof(eliminate_last_char(value));
                return 1;
                break;
              default:
                printf("%s\n", "Error.");
                return 0;
                break;
            }
            break;
          case 2:
            switch (value[strlen(value)-1]) {
              case '1':
                pointer->value.dvalue = (double)atoi(eliminate_last_char(value));
                return 1;
                break;
              case '2':
                pointer->value.dvalue = atof(eliminate_last_char(value));
                return 1;
                break;
              default:
                printf("%s\n", "Error.");
                return 0;
                break;
            }
            break;
          case 3:
            switch (value[strlen(value)-1]) {
              case '3':
                strcpy(pointer->value.svalue, eliminate_last_char(value));
                return 1;
                break;
              default:
                printf("%s\n", "Error.");
                return 0;
                break;
            }
            break;
        }
      }
      pointer = pointer->next;
    }
    return 0;
  }
}

// int main(int argc, char const *argv[]) {
//   char* name = "var1";
//   int type = 1;
//   union value value;
//   value.ivalue = 3;
//
//   Tuple *tuple = create_tuple(name, type, value);
//   Symbol_Table *st = (Symbol_Table*)malloc(sizeof(Symbol_Table));
//   st->head = NULL;
//   st->length = 0;
//   insert_tuple(st, tuple);
//
//   char* name2 = "var2";
//   int type2 = 2;
//   union value value2;
//   value2.dvalue = 2.0;
//
//   Tuple *tuple2 = create_tuple(name2, type2, value2);
//
//   insert_tuple(st, tuple2);
//
//   if (obtain_tuple("var2", st)) {
//     printf("%s\n", "var2 exists");
//   }
//   return 0;
// }
#endif
