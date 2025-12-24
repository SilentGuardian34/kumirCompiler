%{
    #include <iostream>
    #include <string>
    #include <vector>
    
    int yylex();
    void yyerror(const char *s);
    extern FILE* yyin;
%}

%code requires {
    #include <memory>
    #include <vector>
}

%token ALG DANO NADO NACH KON ARG REZ ARGREZ ZNACH ISP UTV
%token NC KC RAZ POKA DLYA OT DO
%token ESLI TO INACHE VIBOR PRI VSE
%token CEL VESH LOG SIM LIT TAB
%token DA NET
%token VVOD VIVOD NS
%token ASSIGN PLUS MINUS MULT DIV
%token EQ NE GT LT GE LE
%token AND OR NOT
%token OPEN_BRACKET CLOSE_BRACKET COLON ENDL
%token INTEGER FLOAT BOOLEAN CHAR STRING NAME

%left AND OR
%right NOT
%nonassoc EQ NE GT LT GE LE
%left PLUS MINUS
%left MULT DIV
%right UMINUS
%right POW

%location
%start program

%%

nl
    : nl ENDL
    | ENDL

opt_nl
    : nl
    |
    ;

algorithm_list
    : algorithm_list nl algorithm
    | algorithm
    ;

algorithm
    : ALG nl algorithm_header nl conditions nl NACH nl statement_list nl KON
    | ALG nl algorithm_header nl NACH nl statement_list nl KON
    ;

algorithm_header
    : type NAME '(' argument_list ')'
    | type NAME
    | NAME '(' argument_list ')'
    | NAME
    ;

argument_list
    : argument_declaration
    | argument_list ',' argument_declaration
    ;

conditions
    : DANO condition_description nl NADO condition_description
    | NADO condition_description
    | DANO condition_description
    ;

argument_declaration
    : type NAME
    | ARG type NAME
    | REZ type NAME
    | ARGREZ type NAME
    ;

statement_list
    : statement_list nl statement
    | statement
    ;

statement
    : VVOD input_list
    | VIVOD output_list
    | ESLI expression opt_nl TO opt_nl statement_list opt_nl INACHE opt_nl statement_list opt_nl VSE
    | ESLI expression opt_nl TO opt_nl statement_list opt_nl VSE
    | NC opt_nl INTEGER RAZ opt_nl statement_list opt_nl KC
    | NC opt_nl POKA expression nl statement_list opt_nl KC
    | NC opt_nl DLYA NAME OT expression DO expression nl statement_list KC
    | type NAME
    | type TAB NAME '[' INTEGER ':' INTEGER ']'
    | expression ASSIGN expression
    | expression
    ;

input_list
    : input_list ',' expression
    | expression
    ;

output_list
    : output_list ',' expression
    | output_list ',' NS
    | expression
    | NS
    ;

type
    : CEL
    | VESH
    | LOG
    | SIM
    | LIT
    ;

expression
    : NAME "[" expression "]"
    | NAME '(' input_list ')'
    | NAME '(' ')'
    | NAME
    | INTEGER
    | FLOAT
    | BOOLEAN
    | CHAR
    | STRING
    | '(' expression ')'
    | expression POW expression
    | expression MULT expression
    | expression DIV expression
    | expression PLUS expression
    | expression MINUS expression
    | NOT expression
    | expression EQ expression
    | expression NE expression
    | expression GT expression
    | expression LT expression
    | expression GE expression
    | expression LE expression
    | expression AND expression
    | expression OR expression
    | MINUS expression
    ;

%%

void yyerror(const char *s) {
    std::cerr << "Syntax error: " << s << std::endl;
}

int main(int argc, char **argv) {
    ++argv, --argc;
    if (argc > 0) {
        yyin = fopen(argv[0], "r");
    } else {
        yyin = stdin;
    }
    
    return yyparse();
}