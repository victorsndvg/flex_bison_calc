%{
#include <stdio.h>  
#include <math.h>
#include <string.h>
#include <dictionary.h>  
#include <definitions.h> 

    struct node {
        struct node *next;
        char *lex;
        int  code;
        float val;
    } *thenode;

    int ERR = 0;

    int yyparse();
    int yylex();

    void clear() {
        printf("\033[H\033[J");
    }

    void help () {
        printf("############################################################\n");
        printf("# Float Scientific calculator v0.1\n");
        printf("# \tOperators:\n");
        printf("# \t\tFloat: +, -, *, /, =\n");
        printf("# \t\tBinary: &, |, ^, <<, >>\n");
        printf("# \tPrecedence modifiers: () and []\n");
        printf("# \tConstants:\n");
        printf("# \t\tpi = 3.1415926535\n");
        printf("# \t\te  = 2.7182818284\n");
        printf("# \tFunctions:\n");
        printf("# \t\tacos, asin, atan, cos, cosh, sin, sinh\n");
        printf("# \t\ttanh, exp, log, log10, sqrt, ceil, fabs\n");
        printf("# \t\tfloor, atan2, frexp, ldexp, modf, pow, fmod\n");
        printf("# \tCommands:\n");
        printf("# \t\thelp(): show this help message\n");
        printf("# \t\tclear(): clear the command line\n");
        printf("# \t\texit(): turn off the scientific calculator\n");
        printf("# Note: \n");
        printf("# \tUse ';' at the end of the line to mute the result\n");
        printf("# \tUse 'const' in assignement for user defined constants\n");
        printf("############################################################\n");
    }

    void initialize_constants() {

        setnode("pi", 3.1415926535, CONSTANT);
        setnode("e", 2.7182818284, CONSTANT);
    }

    void main () {
        clear();
        help();
        initialize_constants();
        printf(" > ");
        yyparse();
    }

    void yyerror (const char *s) {
        printf("[ERROR]: %s \n", s);
    }

    float func(char  *func, float arg) {
        if(strcmp("acos", func)==0) {
            return(acos(arg));
        } else if(strcmp("asin", func)==0) {
            return(asin(arg));
        } else if(strcmp("atan", func)==0) {
            return(atan(arg));
        } else if(strcmp("cos", func)==0) {
            return(cos(arg));
        } else if(strcmp("cosh", func)==0) {
            return(cosh(arg));
        } else if(strcmp("sin", func)==0) {
            return(sin(arg));
        } else if(strcmp("sinh", func)==0) {
            return(sinh(arg));
        } else if(strcmp("tanh", func)==0) {
            return(tanh(arg));
        } else if(strcmp("exp", func)==0) {
            return(exp(arg));
        } else if(strcmp("log", func)==0) {
            return(log(arg));
        } else if(strcmp("log10", func)==0) {
            return(log10(arg));
        } else if(strcmp("sqrt", func)==0) {
            return(sqrt(arg));
        } else if(strcmp("ceil", func)==0) {
            return(ceil(arg));
        } else if(strcmp("fabs", func)==0) {
            return(fabs(arg));
        } else if(strcmp("floor", func)==0) {
            return(floor(arg));
        } else {
            yyerror("unknown function");
        }
    }

    float func2(char  *func, float arg1, float arg2) {
        if(strcmp("atan2", func)==0) {
            return(atan2(arg1, arg2));
        } else if(strcmp("frexp", func)==0) {
            // printf("[WARNING] Integer casting (%f -> %d)", arg2, (int)floor(arg2));
            // return(frexp(arg1, (int)floor(arg2)));
        } else if(strcmp("ldexp", func)==0) {
            return(ldexp(arg1, arg2));
        } else if(strcmp("modf", func)==0) {
            return(fmodf(arg1, arg2));
        } else if(strcmp("pow", func)==0) {
            return(pow(arg1, arg2));
        } else if(strcmp("fmod", func)==0) {
            return(fmod(arg1, arg2));
        } else {
            yyerror("unknown function");
        }
    }

%}

%union {
    float val;
    char *lex;
}

%error-verbose

%start lines
%type  <val> line
%type  <val> exp
%type  <val> factor
%type  <val> bin
%type  <val> term
%token <val> NUMBER
%token <lex> VAR
%token <lex> FUNC
%token <lex> FUNC2
%left        HELP
%left        CLEAR
%left        EXIT
%left        OP 
%left        CP
%left        ADD SUB 
%left        MUL DIV 
%left        AND OR XOR LSHIFT RSHIFT
%left        COMMA
%left        SEMICOLON
%left        CONST
%left        EOL
%right       ASSIGN

%%
lines:
	| lines line SEMICOLON EOL  { printf(" > "); ERR = 0; }
	| lines line EOL  { if( ERR == 0 ) printf("%f \n", $2); printf(" > "); ERR = 0; }
	| lines EOL { printf(" > "); }
	| lines error EOL { printf(" > "); }
	| lines HELP EOL { help(); printf(" > "); }
	| lines CLEAR EOL { clear(); printf(" > "); }
	| lines EXIT EOL { return 0; }
	;
line: 
    exp 
	| VAR ASSIGN exp    { 
                            if((thenode=getnode($1))!=NULL) {
                                if(thenode->code==CONSTANT) {
                                    ERR = 1;
                                    yyerror("cannot override a constant");
                                }
                                thenode->val = $3;
                                $$ = $3;
                            } else if(setnode($1, $3, VAR) == NULL) { 
                                ERR = 1;
                                yyerror("dictionary error"); 
                            } else { 
                                $$ = $3; 
                            };
                        }
	| CONST VAR ASSIGN exp    { 
                            if((thenode=getnode($2))!=NULL) {
                                if(thenode->code==CONSTANT) {
                                    ERR = 1;
                                    yyerror("cannot override a constant");
                                }
                                thenode->val = $4;
                                thenode->code = CONSTANT;
                                $$ = $4;
                            } else if(setnode($2, $4, CONSTANT) == NULL) { 
                                ERR = 1;
                                yyerror("dictionary error"); 
                            } else { 
                                $$ = $4; 
                            };
                        }
	;
exp: 
	factor 
	| exp ADD factor { $$ = $1 + $3; }
	| exp SUB factor { $$ = $1 - $3; }
	| ADD factor { $$ = $2; }
	| SUB factor { $$ = -$2; }
	;
factor: 
    bin 
	| factor MUL bin { $$ = $1 * $3; }
	| factor DIV bin { $$ = $1 / $3; }
	;
bin:
    term
    | bin AND term      {
                            printf("[WARNING] Cast arguments to unsigned int\n"); 
                            $$ = (unsigned int) $1 & (unsigned int) $3; 
                        }
    | bin OR term       {
                            printf("[WARNING] Cast arguments to unsigned int\n"); 
                            $$ = (unsigned int) $1 | (unsigned int) $3; 
                        }
    | bin XOR term      {
                            printf("[WARNING] Cast arguments to unsigned int\n"); 
                            $$ = (unsigned int) $1 ^ (unsigned int) $3; 
                        }
    | bin LSHIFT term   {
                            printf("[WARNING] Cast arguments to unsigned int\n"); 
                            $$ = (unsigned int) $1 << (unsigned int) $3; 
                        }
    | bin RSHIFT term   {
                            printf("[WARNING] Cast arguments to unsigned int\n"); 
                            $$ = (unsigned int) $1 >> (unsigned int) $3; 
                        }
    ;
term: 
    NUMBER 
	| FUNC OP exp CP { $$ = func($1, $3); }
	| FUNC2 OP exp COMMA exp CP { $$ = func2($1, $3, $5); }
	| OP exp CP { $$ = $2; }
    | VAR   { 
                if((thenode = getnode($1)) == NULL) { 
                    ERR = 1;
                    yyerror("undefined variable"); 
                } else { 
                    $$ = thenode->val; 
                }; 
            }
	;
%%


