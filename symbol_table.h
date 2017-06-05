#ifndef symbol_table
#define symbol_table


typedef struct tuple{
    char* name;
    int type; //1 = int, 2 = double and 3 = string
    union value{
        int ivalue;
        float dvalue;
        char* svalue;
    }value;
    struct tuple* next;
}Tuple;


typedef struct symbol_table{
  Tuple* head;
  int length;
}Symbol_Table;

Tuple* create_tuple(char* name ,int type ,union value value){
  Tuple* tuple = (Tuple*)malloc(sizeof(Tuple));
  tuple->name = (char*)malloc(strlen(name));
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
}

void destroy_tuple(Tuple *tuple){
  free(tuple);
}

void insert_tuple(Symbol_Table *symbol_table, Tuple *tuple){
  if (symbol_table->head == NULL) {
    symbol_table->head = tuple;
  }else{
    Tuple *pointer = symbol_table->head;
    while (pointer->next) {
      pointer = pointer->next;
    }
    pointer->next = tuple;
  }
  symbol_table->length++;
}

Tuple* obtain_tuple(char* variable_name, Symbol_Table *symbol_table){
  if (symbol_table->head == NULL) {
    return NULL;
  }else{
    Tuple* pointer = symbol_table->head;
    while (pointer) {
      if (!strcmp(variable_name, pointer->name)) {
        return pointer;
      }
      pointer = pointer->next;
    }
    return NULL;
  }
}

// int main(int argc, char const *argv[]) {
//   char* name = "var1";
//   int type = 1;
//   union value value;
//   value.ivalue = 3;
//
//   Tuple *tuple = create_tuple(name, type, value);
//   Symbol_Table *symbol_table = (Symbol_Table*)malloc(sizeof(Symbol_Table));
//   symbol_table->head = NULL;
//   symbol_table->length = 0;
//   insert_tuple(symbol_table, tuple);
//
//   char* name2 = "var2";
//   int type2 = 2;
//   union value value2;
//   value2.dvalue = 2.0;
//
//   Tuple *tuple2 = create_tuple(name2, type2, value2);
//
//   insert_tuple(symbol_table, tuple2);
//
//   if (obtain_tuple("var2", symbol_table)) {
//     printf("%s\n", "var2 exists");
//   }
//   return 0;
// }
#endif
