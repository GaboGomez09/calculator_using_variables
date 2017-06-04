Design and implementation of a calculator with the capability of using variables.

Using FLEX 2.6.0, BISON 3.0.4 and a Symbol Table written in C.

Class: Compilers

Requirements:

  *Design a lexical analyzer that identifies the following lexemes.
    + Whole numbers with or without minus symbol. Example (5, 34, -100)
    + Decimal numbers with or without minus symbol. Example (.05, 0.51, -13.1)
    + Variables (with the same REGEX used in past assignment)
    + Math operators (=,+, -, *, /, % and ^)
    + Strings ("Everything between double apostrophes")
    + End of expression symbol (;)

*Design a Parser that recognizes the grammar for the following forms:
    + Declare a variable: Examples
       int var1;
       double var2;
       string var3;
    + Declare and initialize a variable: Examples
       int var1 = 4;
       string var3 = “hola mundo”;
    + Assign values or valid expressions to a variable. Examples:
       var1 = 5;
       var1= varWhole1 + varWhole2;
       var3 = “hello again”;
    + Mathematical Operations, adding the control of variables declared in the
    grammar section(the operations can be between variables and values that are
    whole or decimal).
       For Strings only the sum and subtract operation("hello" + "world"
      results in "helloworld", "helloworld"-"lo" results in "helworld").
