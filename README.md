# Mini Compiler for PHP : 
The project aimed at building a mini-complier for PHP. The language constructs supported by the mini-complier are “switch” and “foreach”. Along with these we have handled arrays and expressions.
## Architecture of the Language :
  - Variable declarations
  - Variable assignments
  - Arithmetic expressions
  - Assignment statements
  - Array declarations
  - Array assignments
  - For each condition expressions
  - Switch Cases
  - Switch condition expressions
  - Types : Identifier, Keyword, Number , literal
  - Comments
  - Parenthesis matching
  - Error reporting with line numbers
## Design stratergy and implementation details :
#### Symbol table creation :
As a part of symbol table we are storing line number, name of the identifier, flag
for array type and type of the variable.
Before inserting anything into the symbol table lookup function is called in-order
to check if that particular elements exists in the symbol table. If it exists we just
update the line number of that particular element.
In any expressions if there is an identifier used, search_id function is called in-
order to verify if the identifier is defined before in the program.
In particular constructs like “foreach” where it is mandatory to use only array
types we are making sure this by calling is_array function.
#### Abstarct syntax tree : 
  - Expressions <br /> For expressions the every leaf node of the tree is an operand and the
intermediate nodes represent the operators. The operators having higher precedence are farther to the root of AST when compared to the operators which have lower precedence, because higher precedence 
operators must be evaluated first relative to lower precedence operators. <br /> <br />
  - foreach <br /> AST implementation for “foreach” incorporates the same basic structure of tree
node as above. For each AST contains an expression array which holds the roots
of all the expressions inside “foreach”. Left subtree contains the condition
expression and right subtree which is an n-array tree contains all the expressions
inside “foreach” block.
#### Intermediate code generation :  
Intermediate code is built using AST and a character stack. The logic used here is
that whenever we encounter an operator we create a temporary variable by
calling create_temp function otherwise we just push the operand into the stack.
On creation of temporary variable we push this variable into the stack as other
expressions might depend on the value of temporary variable.
## Compilation steps :
Make sure that input is stored in input.txt
  - lex php_lex.l
  - yacc php_yacc.y
  - gcc lex.yyc y.tab.c -o run
  - ./run
