%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #define YYSTYPE char *
  int yylex();
  void yyerror(char *);
  void lookup(char *,int ,int ,int );
  void insert(char *,int ,int ,int );
  void search_id(char *,int );
  void is_arr(char *,int );
  extern FILE *yyin;
  extern int yylineno;
  extern char *yytext;
  typedef struct symbol_table
  {
    int line;
    char name[31];
    int flag_array;
    char type[15];
  }ST;
  int struct_index = 0;
  ST st[10000];
  typedef struct tree_node
  {
    struct tree_node *left;
    struct tree_node *right;
    char *operand;
  }tree_node;
  tree_node *build_tree(char *,tree_node *,tree_node *);
  void printTree(tree_node *);
  void print_for(tree_node *);
  int tree_count = 0;
  tree_node *exp_arr[1000];
  int exp_index = 0;
  tree_node *switch_case[100];
  int case_index = 0;
  tree_node *switch_exp[1000];
  int switch_exp_index = 0;
  void copy(tree_node **);
  void print_switch(tree_node *);
  int len[100];
  int len_index = 0;
  void icg(tree_node *);
  char stack[100][33];
  int top = -1;
  char *create_temp();
  int temp_num = 0;
  void icg_foreach(tree_node *);
  char *create_label();
  int label_index = 0;
  typedef struct quad
  {
    char operand1[35];
    char operand2[35];
    char res[35];
    char operator[35];
  }quad;
  quad quad_table[1000];
  int quad_index = 0;
  void print_quad();
%}

%token T_START T_END T_LE T_GE T_NEC T_NE T_EQC T_EXP T_AND
%token T_OR T_XOR T_FE T_AS T_CASE T_BR T_DF NUM T_LT T_GT
%token T_NOT T_OP T_CP T_OB T_CB T_SC T_C T_PL T_MIN T_STAR T_DIV T_MOD T_EQL
%token T_EQ T_ID T_SW T_COM T_ARR T_STR T_ECH T_SQO T_SQC
%right T_EQL
%left T_PL T_MIN
%left T_STAR T_DIV
%start Start
%%

Start :T_START Statements T_END {lookup($1,@1.last_line,0,0);lookup($3,@3.last_line,0,0);};
  ;

Statements: Statements Assignment T_SC {lookup($3,@3.last_line,0,5);};
  |Assignment T_SC  {lookup($2,@2.last_line,0,5);};
  |Statements Switch_Stat {case_index = 0;};
  |Switch_Stat {case_index = 0;};
  |Statements Foreach_Stat {exp_index = 0;};
  |Foreach_Stat {exp_index = 0;};
  |Statements Echo
  |Echo
  |Statements Array_stat
  |Array_stat
  ;

Echo:T_ECH T_STR T_SC {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,6);};
  ;

Array_stat:T_ID T_EQL T_ARR T_OB Data T_COM NUM T_CB T_SC {lookup($1,@1.last_line,1,4);lookup($2,@2.last_line,0,1);lookup($3,@3.last_line,0,0);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,5);lookup($7,@7.last_line,0,4);lookup($8,@8.last_line,0,5);lookup($9,@9.last_line,0,5);};
  |T_ID T_EQL T_ARR T_OB Data T_COM T_ID T_CB T_SC{lookup($1,@1.last_line,1,4);lookup($2,@2.last_line,0,1);lookup($3,@3.last_line,0,0);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,5);search_id($7,@7.last_line);lookup($7,@7.last_line,0,4);lookup($8,@8.last_line,0,5);lookup($9,@9.last_line,0,5);};
  ;

Foreach_Stat : T_FE T_OB T_ID T_AS T_ID T_CB T_OP Foreach_Blk T_CP {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,5);is_arr($3,@3.last_line);search_id($3,@3.last_line);lookup($3,@3.last_line,0,4);tree_node *as_left = build_tree($3,NULL,NULL);lookup($4,@4.last_line,0,0);lookup($5,@5.last_line,0,4);
  tree_node *as_right = build_tree($5,NULL,NULL);tree_node *as_sub = build_tree($4,as_left,as_right);tree_node *for_node = build_tree($1,as_sub,exp_arr);lookup($6,@6.last_line,0,5);lookup($7,@7.last_line,0,5);lookup($9,@9.last_line,0,5);printf("Tree %d\n",tree_count);tree_count++;print_for(for_node);icg_foreach(for_node);};

Foreach_Blk : foreach_St1;

foreach_St1 : foreach_St1 foreach_exp T_SC {lookup($3,@3.last_line,0,5);};
	| foreach_exp T_SC {lookup($2,@2.last_line,0,5);};
  |foreach_St1 T_ECH T_STR T_SC {lookup($2,@2.last_line,0,0);lookup($3,@3.last_line,0,6);lookup($4,@4.last_line,0,5);};
  |T_ECH T_STR T_SC {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,6);lookup($2,@2.last_line,0,5);};
  |foreach_St1 T_ID T_EQL T_ARR T_OB Data T_COM NUM T_CB T_SC {lookup($2,@2.last_line,1,4);lookup($3,@3.last_line,0,1);lookup($4,@4.last_line,0,0);lookup($5,@5.last_line,0,5);lookup($7,@7.last_line,0,5);lookup($8,@8.last_line,0,3);lookup($9,@9.last_line,0,5);lookup($10,@10.last_line,0,5);};
  |T_ID T_EQL T_ARR T_OB Data T_COM NUM T_CB T_SC {lookup($1,@1.last_line,1,4);lookup($2,@2.last_line,0,1);lookup($3,@3.last_line,0,0);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,5);lookup($7,@7.last_line,0,3);lookup($8,@8.last_line,0,5);lookup($9,@9.last_line,0,5);};
  |foreach_St1 T_ID T_EQL T_ARR T_OB Data T_COM T_ID T_CB T_SC {lookup($2,@2.last_line,1,4);lookup($3,@3.last_line,0,1);lookup($4,@4.last_line,0,0);lookup($5,@5.last_line,0,5);lookup($7,@7.last_line,0,5);search_id($8,@8.last_line);lookup($8,@8.last_line,0,4);lookup($9,@9.last_line,0,5);lookup($10,@10.last_line,0,5);};
  |T_ID T_EQL T_ARR T_OB Data T_COM T_ID T_CB T_SC {lookup($1,@1.last_line,1,4);lookup($2,@2.last_line,0,1);lookup($3,@3.last_line,0,0);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,5);search_id($7,@7.last_line);lookup($7,@7.last_line,0,4);lookup($8,@8.last_line,0,5);lookup($9,@9.last_line,0,5);};
  ;

foreach_exp :foreach_Assignment
  ;
foreach_Assignment: T_ID T_EQL foreach_exp1 {lookup($1,@1.last_line,0,4);tree_node *left_part = build_tree($1,NULL,NULL);$$ = build_tree($2,left_part,$3);exp_arr[exp_index] = $$;exp_index = exp_index + 1;};

foreach_exp1 : foreach_exp1 T_PL foreach_exp1 {$$=build_tree($2,$1,$3);};
	|foreach_exp1 T_MIN foreach_exp1 {$$=build_tree($2,$1,$3);};
	|foreach_exp1 T_STAR foreach_exp1 {$$=build_tree($2,$1,$3);};
	|foreach_exp1 T_DIV foreach_exp1 {$$=build_tree($2,$1,$3);};
  |T_ID T_SQO NUM T_SQC {is_arr($1,@1.last_line);char *arr_string=(char *)malloc(sizeof(char)*40);strcat(arr_string,$1);strcat(arr_string,$2);strcat(arr_string,$3);strcat(arr_string,$4);$$=build_tree(arr_string,NULL,NULL);};
  |T_ID T_SQO T_ID T_SQC {is_arr($1,@1.last_line);search_id($3,@3.last_line);char *arr_str = (char *)malloc(sizeof(char)*40);strcat(arr_str,$1);strcat(arr_str,$2);strcat(arr_str,$3);strcat(arr_str,$4);$$=build_tree(arr_str,NULL,NULL);};
	|T_ID {search_id($1,@1.last_line);lookup($1,@1.last_line,0,4);$$=build_tree($1,NULL,NULL);};
	|NUM {lookup($1,@1.last_line,0,3);$$=build_tree($1,NULL,NULL);};
	;

Switch_Stat : T_SW T_OB switch_exp2 T_CB T_OP Switch_Blk T_CP {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,5);lookup($4,@4.last_line,0,5);lookup($5,@5.last_line,0,5);lookup($7,@7.last_line,0,5);tree_node *switch_tree = build_tree($1,$3,switch_case);print_switch(switch_tree);printf("\n");};

switch_exp2 : switch_exp2 T_PL switch_exp2 {$$=build_tree($2,$1,$3);};
	|switch_exp2 T_MIN switch_exp2 {$$=build_tree($2,$1,$3);};
	|switch_exp2 T_STAR switch_exp2 {$$=build_tree($2,$1,$3);};
	|switch_exp2 T_DIV switch_exp2 {$$=build_tree($2,$1,$3);};
	|T_ID {search_id($1,@1.last_line);lookup($1,@1.last_line,0,4);$$=build_tree($1,NULL,NULL);};
	|NUM {lookup($1,@1.last_line,0,3);$$=build_tree($1,NULL,NULL);};
  |T_ID T_SQO NUM T_SQC {is_arr($1,@1.last_line);char *arr_string=(char *)malloc(sizeof(char)*40);strcat(arr_string,$1);strcat(arr_string,$2);strcat(arr_string,$3);strcat(arr_string,$4);$$=build_tree(arr_string,NULL,NULL);};
  |T_ID T_SQO T_ID T_SQC {is_arr($1,@1.last_line);search_id($3,@3.last_line);char *arr_str = (char *)malloc(sizeof(char)*40);strcat(arr_str,$1);strcat(arr_str,$2);strcat(arr_str,$3);strcat(arr_str,$4);$$=build_tree(arr_str,NULL,NULL);};
  ;

Switch_Blk : CaseBlock /*{switch_case[case_index] = $1;case_index = case_index + 1;};*/
| CaseBlock DEF {lookup($2,@2.last_line,0,0);/*switch_case[case_index] = $2;case_index = case_index + 1;*/};
  ;

CaseBlock :CaseBlock T_CASE NUM T_C switch_St1 {lookup($2,@2.last_line,0,0);lookup($3,@3.last_line,0,3);tree_node *num = build_tree($3,NULL,NULL);lookup($4,@4.last_line,0,5);
  tree_node **temp = (tree_node **)malloc(sizeof(tree_node *)*1000);copy(temp);$$ = build_tree($2,num,temp);switch_case[case_index] = $$;case_index = case_index + 1;len[len_index] = switch_exp_index;len_index++;switch_exp_index = 0;};
  |CaseBlock T_CASE NUM T_C switch_St1 T_BR T_SC {lookup($2,@2.last_line,0,0);lookup($3,@3.last_line,0,3);tree_node *num = build_tree($3,NULL,NULL);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,0);lookup($7,@7.last_line,0,5);
    tree_node **temp = (tree_node **)malloc(sizeof(tree_node *)*1000);copy(temp);$$ = build_tree($2,num,temp);switch_case[case_index] = $$;case_index = case_index + 1;len[len_index] = switch_exp_index;len_index++;switch_exp_index = 0;};
  |
  ;

DEF : T_DF T_C switch_St1 T_BR T_SC  {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,5);lookup($4,@4.last_line,0,0);lookup($5,@5.last_line,0,5);
tree_node **temp = (tree_node **)malloc(sizeof(tree_node *)*1000);copy(temp);$$ = build_tree($1,'0',temp);switch_exp_index = 0;};
	|T_DF T_C switch_St1  {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,5);
  tree_node **temp = (tree_node **)malloc(sizeof(tree_node *)*1000);copy(temp);$$ = build_tree($1,'0',temp);switch_exp_index = 0;};
	;

switch_St1 : switch_St1 switch_exp T_SC {lookup($3,@3.last_line,0,5);};
	| switch_exp T_SC {lookup($2,@2.last_line,0,5);};
  |switch_St1 T_ECH T_STR T_SC {lookup($2,@2.last_line,0,0);lookup($3,@3.last_line,0,6);lookup($4,@4.last_line,0,5);};
  |T_ECH T_STR T_SC {lookup($1,@1.last_line,0,0);lookup($2,@2.last_line,0,6);lookup($2,@2.last_line,0,5);};
  |switch_St1 T_ID T_EQL T_ARR T_OB Data T_COM NUM T_CB T_SC {lookup($2,@2.last_line,1,4);lookup($3,@3.last_line,0,1);lookup($4,@4.last_line,0,0);lookup($5,@5.last_line,0,5);lookup($7,@7.last_line,0,5);lookup($8,@8.last_line,0,3);lookup($9,@9.last_line,0,5);lookup($10,@10.last_line,0,5);};
  |T_ID T_EQL T_ARR T_OB Data T_COM NUM T_CB T_SC {lookup($1,@1.last_line,1,4);lookup($2,@2.last_line,0,1);lookup($3,@3.last_line,0,0);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,5);lookup($7,@7.last_line,0,3);lookup($8,@8.last_line,0,5);lookup($9,@9.last_line,0,5);};
  |switch_St1 T_ID T_EQL T_ARR T_OB Data T_COM T_ID T_CB T_SC {lookup($2,@2.last_line,1,4);lookup($3,@3.last_line,0,1);lookup($4,@4.last_line,0,0);lookup($5,@5.last_line,0,5);lookup($7,@7.last_line,0,5);search_id($8,@8.last_line);lookup($8,@8.last_line,0,4);lookup($9,@9.last_line,0,5);lookup($10,@10.last_line,0,5);};
  |T_ID T_EQL T_ARR T_OB Data T_COM T_ID T_CB T_SC {lookup($1,@1.last_line,1,4);lookup($2,@2.last_line,0,1);lookup($3,@3.last_line,0,0);lookup($4,@4.last_line,0,5);lookup($6,@6.last_line,0,5);search_id($7,@7.last_line);lookup($7,@7.last_line,0,4);lookup($8,@8.last_line,0,5);lookup($9,@9.last_line,0,5);};
  ;

switch_exp :switch_Assignment
  ;
switch_Assignment: T_ID T_EQL switch_exp1 {lookup($1,@1.last_line,0,4);tree_node *left_part = build_tree($1,NULL,NULL);$$ = build_tree($2,left_part,$3);switch_exp[switch_exp_index] = $$;switch_exp_index = switch_exp_index + 1;};

switch_exp1 : switch_exp1 T_PL switch_exp1 {$$=build_tree($2,$1,$3);};
	|switch_exp1 T_MIN switch_exp1 {$$=build_tree($2,$1,$3);};
	|switch_exp1 T_STAR switch_exp1 {$$=build_tree($2,$1,$3);};
	|switch_exp1 T_DIV switch_exp1 {$$=build_tree($2,$1,$3);};
  |T_ID T_SQO NUM T_SQC {is_arr($1,@1.last_line);char *arr_string=(char *)malloc(sizeof(char)*40);strcat(arr_string,$1);strcat(arr_string,$2);strcat(arr_string,$3);strcat(arr_string,$4);$$=build_tree(arr_string,NULL,NULL);};
  |T_ID T_SQO T_ID T_SQC {is_arr($1,@1.last_line);search_id($3,@3.last_line);char *arr_str = (char *)malloc(sizeof(char)*40);strcat(arr_str,$1);strcat(arr_str,$2);strcat(arr_str,$3);strcat(arr_str,$4);$$=build_tree(arr_str,NULL,NULL);};
	|T_ID {search_id($1,@1.last_line);lookup($1,@1.last_line,0,4);$$=build_tree($1,NULL,NULL);};
	|NUM {lookup($1,@1.last_line,0,3);$$=build_tree($1,NULL,NULL);};
	;

Assignment: T_ID T_EQL exp1 {lookup($1,@1.last_line,0,4);tree_node *left_part = build_tree($1,NULL,NULL);$$ = build_tree($2,left_part,$3);printf("Tree %d\n",tree_count);tree_count++;printTree($$);printf("\n");icg($$);top = -1;};

exp1 : exp1 T_PL exp1 {$$=build_tree($2,$1,$3);};
	|exp1 T_MIN exp1 {$$=build_tree($2,$1,$3);};
	|exp1 T_STAR exp1 {$$=build_tree($2,$1,$3);};
	|exp1 T_DIV exp1 {$$=build_tree($2,$1,$3);};
  |T_ID T_SQO NUM T_SQC {is_arr($1,@1.last_line);char *arr_string=(char *)malloc(sizeof(char)*40);strcat(arr_string,$1);strcat(arr_string,$2);strcat(arr_string,$3);strcat(arr_string,$4);$$=build_tree(arr_string,NULL,NULL);};
  |T_ID T_SQO T_ID T_SQC {is_arr($1,@1.last_line);search_id($3,@3.last_line);char *arr_str = (char *)malloc(sizeof(char)*40);strcat(arr_str,$1);strcat(arr_str,$2);strcat(arr_str,$3);strcat(arr_str,$4);$$=build_tree(arr_str,NULL,NULL);};
	|T_ID {search_id($1,@1.last_line);lookup($1,@1.last_line,0,4);$$=build_tree($1,NULL,NULL);};
	|NUM {lookup($1,@1.last_line,0,3);$$=build_tree($1,NULL,NULL);};
	;

Data :Data T_COM NUM {lookup($2,@2.last_line,0,5);lookup($3,@3.last_line,0,3);};
  |NUM {lookup($1,@1.last_line,0,3);};
  |Data T_COM T_ID {lookup($2,@2.last_line,0,5);search_id($3,@3.last_line);lookup($3,@3.last_line,0,4);};
  |T_ID {search_id($1,@1.last_line);lookup($1,@1.last_line,0,4);};
  ;

%%

int main(int argc,char *argv[])
{
  printf("--------------------Syntax tree of the program------\n");
  yyin = fopen("input_or.txt","r");
  if(!yyparse())  //yyparse-> 0 if success
  {
    printf("Parsing Complete\n");
    printf("-----------------------Symbol Table-----------------\n");
    for(int i = 0;i < struct_index;i++)
    {
      printf("%d Token %s Line number %d Is Array %d %s\n",i+1,st[i].name,st[i].line,st[i].flag_array,st[i].type);
    }
    print_quad();
  }
  else
  {
    printf("Parsing failed\n");
  }
  fclose(yyin);
  return 0;
}

void yyerror(char *s)
{
  printf("Error :%s at %d \n",yytext,yylineno);
}

void lookup(char *token,int line,int is_array,int type)
{
  //printf("Token %s line number %d\n",token,line);
  int flag = 0;
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(st[i].name,token))
    {
      flag = 1;
      if(st[i].line != line)
      {
        st[i].line = line;
      }
    }
  }
  if(flag == 0)
  {
    insert(token,line,is_array,type);
  }
}
void insert(char *token,int line,int is_array,int type)
{
  strcpy(st[struct_index].name,token);
  st[struct_index].line = line;
  st[struct_index].flag_array = is_array;
  switch(type)
  {
    case 0:strcpy(st[struct_index].type,"Keyword");
           break;
    case 1:strcpy(st[struct_index].type,"Operator");
          break;
    case 2:strcpy(st[struct_index].type,"Rel_Op");
          break;
    case 3:strcpy(st[struct_index].type,"Number");
          break;
    case 4:strcpy(st[struct_index].type,"Identifier");
          break;
    case 5:strcpy(st[struct_index].type,"Punctuation");
        break;
    case 6:strcpy(st[struct_index].type,"Literal");
        break;
    default:strcpy(st[struct_index].type,"Error");
  }
  struct_index++;
}
void search_id(char *token,int lineno)
{
  int flag = 0;
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(st[i].name,token))
    {
      /* if(st[i].flag_array == 1)
      {
        printf("Error at line %d : array index is not defined\n",lineno,token);
        exit(0);
      } */
      flag = 1;
      return;
    }
  }
  if(flag == 0)
  {
    printf("Error at line %d : %s is not defined\n",lineno,token);
    exit(0);
  }
}
tree_node *build_tree(char *operand,tree_node *left,tree_node *right)
{
  //printf("Building\n");
  tree_node *new_node = (tree_node *)malloc(sizeof(tree_node));
  new_node -> left = left;
  new_node -> right = right;
  char *new_operand = (char *)malloc(sizeof(char) * strlen(operand));
  strcpy(new_operand,operand);
  //printf("operand%s\n",operand);
  new_node -> operand = new_operand;
  //printf("Hii\n");
  return new_node;
}
void printTree(tree_node *tree)
{
	//printf("treeoooooooooooooooooooooooooooooo\n");
	if(tree->left || tree->right)
		printf("(");
  if(tree -> operand != NULL)
	 printf(" %s ",tree->operand);
	if(tree->left)
		printTree(tree->left);
	if(tree->right)
		printTree(tree->right);
	if(tree->left || tree->right)
		printf(")");
}
void is_arr(char *token,int lineno)
{
  int flag;
  for(int i = 0;i < struct_index;i++)
  {
    if(!strcmp(token,st[i].name))
    {
      flag = 1;
      if(st[i].flag_array == 1)
      {
        return;
      }
      else
      {
        printf("Error at line %d : %s is not array type\n",lineno,token);
        exit(0);
      }
    }
  }
  if(flag == 0)
  {
    printf("Error at line %d : %s is not defined\n",lineno,token);
    exit(0);
  }
}
void print_for(tree_node *root)
{
  /* printf("For each blocks\n");
  for(int i = 0;i < exp_index;i++)
  {
    printTree(exp_arr[i]);
  }
  printf("\n");
  printf("For each blocks ends\n"); */
  printf("( %s ( %s ( %s %s ))(",root -> operand,root -> left -> operand,root -> left -> left -> operand,root -> left -> right -> operand);
  for(int i = 0;i < exp_index;i++)
  {
    printTree(exp_arr[i]);
  }
  printf(")\n");
}
void copy(tree_node **temp)
{
  for(int i = 0;i < switch_exp_index;i++)
  {
    temp[i] = switch_exp[i];
  }
}
void print_switch(tree_node *root)
{
  printf("Switch tree\n");
  printf("(%s (",root -> operand);
  printTree(root -> left);
  printf(" )(");
  //printf("CAse index %d\n",case_index);
  for(int i = 0;i < case_index;i++)
  {
    printf(" %s %s ",switch_case[i]->operand,switch_case[i] -> left -> operand);
    for(int j = 0;j < len[i];j++)
    {
      printTree(switch_case[i]->right+j);
    }
  }
}
void icg(tree_node *root)
{
  if(root)
  {
    icg(root -> left);
    icg(root -> right);
    if(root -> operand[0] == '+' || root -> operand[0] == '-' || root -> operand[0] == '*' || root -> operand[0] == '/')
    {
      char *temp = create_temp();
      char operand1[35],operand2[35];
      strcpy(operand2,stack[top]);
      top = top - 1;
      strcpy(operand1,stack[top]);
      top = top - 1;
      printf("%s = %s %s %s\n",temp,operand1,root->operand,operand2);
      strcpy(quad_table[quad_index].operand1,operand1);
      strcpy(quad_table[quad_index].operand2,operand2);
      strcpy(quad_table[quad_index].res,temp);
      strcpy(quad_table[quad_index].operator,root->operand);
      quad_index = quad_index + 1;
      /* printf("In Quadruple form\n");
      printf("Operation  arg1  arg2  res\n");
      printf("%s         %s     %s   %s\n",root -> operand,operand1,operand2,temp); */
      top = top + 1;
      strcpy(stack[top],temp);
    }
    else if( root -> operand[0] == '=')
    {
      char operand1[35],operand2[35];
      strcpy(operand2,stack[top]);
      top = top - 1;
      strcpy(operand1,stack[top]);
      top = top - 1;
      printf("%s %s %s\n",operand1,root -> operand,operand2);
      strcpy(quad_table[quad_index].operand1,operand2);
      strcpy(quad_table[quad_index].operand2,"NULL");
      strcpy(quad_table[quad_index].operator,root->operand);
      strcpy(quad_table[quad_index].res,operand1);
      quad_index = quad_index + 1;
      /* printf("In Quadruple form\n");
      printf("Operation  arg1  arg2  res\n");
      printf("%s         %s    NULL  %s\n",root -> operand,operand2,operand1); */
    }
    else
    {
      top = top + 1;
      strcpy(stack[top],root -> operand);
    }
  }
}
char *create_temp()
{
  int temp = temp_num;
  int unit;
  char char_num[3];
  int temp_index = 0;
  if(temp >= 10)
  {
     unit = temp % 10;
     temp = temp / 10;
     char_num[1] = unit + '0';
     char_num[0] = temp + '0';
     char_num[2] = '\0';
  }
  else
  {
    char_num[0] = temp + '0';
    //printf("Temp %d\n",temp);
    //printf("char %c\n",char_num[0]);
    char_num[1] = '\0';
  }
  char *temp_var = (char *)malloc(sizeof(char) * 5);
  temp_var[0] = 't';
  temp_index = 0;
  while(char_num[temp_index] != '\0')
  {
    temp_var[temp_index + 1] = char_num[temp_index];
    temp_index = temp_index + 1;
  }
  temp_var[temp_index+1] = '\0';
  //printf("temp_var %s\n",temp_var);
  temp_num = temp_num + 1;
  return temp_var;
}
void icg_foreach(tree_node *root)
{
  //printf("------------------------------ICG---------------------\n");
  char *temp = create_temp(); // t0
  printf("%s = 0\n",temp);
  strcpy(quad_table[quad_index].operand1,"0");
  strcpy(quad_table[quad_index].operand2,"NULL");
  strcpy(quad_table[quad_index].operator,"=");
  strcpy(quad_table[quad_index].res,temp);
  quad_index = quad_index + 1;
  char *label = create_label();
  printf("param %s\n",root -> left -> left -> operand);
  strcpy(quad_table[quad_index].operand1,root -> left -> left -> operand);
  strcpy(quad_table[quad_index].operand2,"NULL");
  strcpy(quad_table[quad_index].operator,"param");
  strcpy(quad_table[quad_index].res,"NULL");
  quad_index = quad_index + 1;
  char *temp1 = create_temp();
  printf("%s = call len,1\n",temp1);
  strcpy(quad_table[quad_index].operand1,"len");
  strcpy(quad_table[quad_index].operand2,"1");
  strcpy(quad_table[quad_index].operator,"call");
  strcpy(quad_table[quad_index].res,temp1);
  quad_index = quad_index + 1;
  printf("%s :\n",label);
  strcpy(quad_table[quad_index].operand1,"NULL");
  strcpy(quad_table[quad_index].operand2,"NULL");
  strcpy(quad_table[quad_index].operator,"label");
  strcpy(quad_table[quad_index].res,label);
  quad_index = quad_index + 1;
  char *temp2 = create_temp();
  char *label1 = create_label();
  printf("%s = %s < %s\n",temp2,temp,temp1);
  strcpy(quad_table[quad_index].operand1,temp);
  strcpy(quad_table[quad_index].operand2,temp1);
  strcpy(quad_table[quad_index].operator,"<");
  strcpy(quad_table[quad_index].res,temp2);
  quad_index = quad_index + 1;
  printf("ifFalse %s goto %s\n",temp2,label1);
  strcpy(quad_table[quad_index].operand1,temp2);
  strcpy(quad_table[quad_index].operand2,"NULL");
  strcpy(quad_table[quad_index].operator,"ifFalse");
  strcpy(quad_table[quad_index].res,label1);
  quad_index = quad_index + 1;
  for(int i = 0;i < exp_index;i++)
  {
    icg(exp_arr[i]);
  }
  printf("%s = %s + 1\n",temp,temp);
  strcpy(quad_table[quad_index].operand1,temp);
  strcpy(quad_table[quad_index].operand2,"1");
  strcpy(quad_table[quad_index].operator,"+");
  strcpy(quad_table[quad_index].res,temp);
  quad_index = quad_index + 1;
  printf("goto %s\n",label);
  strcpy(quad_table[quad_index].operand1,"NULL");
  strcpy(quad_table[quad_index].operand2,"NULL");
  strcpy(quad_table[quad_index].operator,"goto");
  strcpy(quad_table[quad_index].res,label);
  quad_index = quad_index + 1;
  printf("%s :NEXT STATEMENTS\n",label1);
  strcpy(quad_table[quad_index].operand1,"NULL");
  strcpy(quad_table[quad_index].operand2,"NULL");
  strcpy(quad_table[quad_index].operator,"label");
  strcpy(quad_table[quad_index].res,label1);
  quad_index = quad_index + 1;
}

char* create_label()
{
  int temp = label_index;
  char char_num[3];
  int unit;
  int temp_index = 0;
  if(temp >= 10)
  {
     unit = temp % 10;
     temp = temp / 10;
     char_num[1] = unit + '0';
     char_num[0] = temp + '0';
     char_num[2] = '\0';
  }
  else
  {
    char_num[0] = temp + '0';
    //printf("Temp %d\n",temp);
    //printf("char %c\n",char_num[0]);
    char_num[1] = '\0';
  }
  char *label = (char *)malloc(sizeof(char) * 10);
  label[0] = 'L';
  label[1] = 'a';
  label[2] = 'b';
  label[3] = 'e';
  label[4] = 'l';
  label[5] = ' ';
  while(char_num[temp_index] != '\0')
  {
    label[temp_index + 5] = char_num[temp_index];
    temp_index = temp_index + 1;
  }
  label[temp_index + 5] = '\0';
  label_index = label_index + 1;
  return label;
}
void print_quad()
{
  printf("----------------------Quadruple---------------------------\n");
  printf("Operator  Arg1  Arg2  Result\n");
  for(int i = 0;i < quad_index;i++)
  {
    //printf("Operator  Arg1  Arg2  Result\n");
    printf("%s      %s    %s    %s\n",quad_table[i].operator,quad_table[i].operand1,quad_table[i].operand2,quad_table[i].res);
  }
}
