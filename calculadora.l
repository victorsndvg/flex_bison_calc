%{
#include <calculadora.tab.h>
#include <dictionary.h>
%}

DIGIT    [0-9]
INT      {DIGIT}+
FLOAT    ({DIGIT}+[.]{DIGIT}*)|({DIGIT}*[.]{DIGIT}+)
EXP1     ({INT}|{FLOAT})[e|E]{INT}
EXP2     ({INT}|{FLOAT})[eE][+-]{INT}
SCI      ({EXP1}|{EXP2})
CHAR     [a-zA-Z]
HEX      [0x][a-zA-Z0-9_]+
ALPHA    [a-zA-Z][a-zA-Z0-9_]*

%%

"exit()"                    { return(EXIT); }
"help()"                    { return(HELP); }
"clear()"                   { return(CLEAR); }
"const"                     { return(CONST); }
"acos"|"asin"|"atan"|"cos"|"cosh"|"sin"|"sinh"|"tanh"|"exp"|"log"|"log10"|"sqrt"|"ceil"|"fabs"|"floor" { 
                              yylval.lex = strdup(yytext); return(FUNC); 
                            }
"atan2"|"frexp"|"ldexp"|"modf"|"pow"|"fmod" { 
                              yylval.lex = strdup(yytext); return(FUNC2); 
                            }
{ALPHA}                     { yylval.lex = strdup(yytext); return(VAR); }
{HEX}|{SCI}|{FLOAT}|{INT}   { yylval.val = atof(yytext); return(NUMBER); }
"="                         { return(ASSIGN); }
"+"                         { return(ADD); }
"-"                         { return(SUB); }
"*"                         { return(MUL); }
"/"                         { return(DIV); }
"&"                         { return(AND); }
"|"                         { return(OR); }
"^"                         { return(XOR); }
"<<"                        { return(LSHIFT); }
">>"                        { return(RSHIFT); }
"("|"["                     { return(OP); }
")"|"]"                     { return(CP); }
","                         { return(COMMA); }
";"                         { return(SEMICOLON); }
\n                          { return(EOL); }
[ \t]+                      { /*ignore*/ }
.                           { printf("[ERROR] Unknown symbol: %s \n", yytext); }

%%


