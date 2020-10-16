%{
#include <stdio.h>
#include <stdlib.h>

//ERROR
#define ERROR 0

//KEYWORDS - 1XX
#define KEYWORD 100
#define PROGRAMSYM 101
#define RETURNSYM 102
#define BEGINSYM 103
#define ENDSYM 104
#define IF 105
#define THEN 106
#define ELSE 107
#define WHILE 108
#define FOR 109

//IDENTIFIER - 200
#define IDENTIFIER 200

//OPERATORS - 3XX
#define MATH_OP 300
#define LOGICAL_OP 301
#define ASSIGNMENT 302
#define COMPARISON 303

//VAR_TYPES - 4XX
#define REAL 400
#define ARRAY 401
#define RECORD 402
#define INTEGER 403
#define NUMERIC 404
#define CONST_INT 405	
#define CONST_STR 406
#define CONST_VAL 407

//SYMBOLS - 5XX
#define NEWLINE 500
#define L_PAREN 501
#define R_PAREN 502
#define L_BRACKET 503
#define R_BRACKET 504
#define WHITESPACE 505
#define SEMICOLON 506
#define COLON 507
#define COMMA 508
#define DOT 509

typedef struct token {
	int type;
	int line;
	char *lexeme;
} Token;

FILE *output;
Token *token_list;
int list_size = 0;
int cursor_line = 1;

/*USER ROUTINES*/

void print_token(Token token, int i)
{
	printf("%d --------------------------------------\n", i);
	printf("token: %d \n", token.type);
	printf("lexeme: %s \n", token.lexeme);
	printf("line: %d \n", token.line);
}

void print_list(Token *token_list, int list_size)
{
	int i;

	for(i = 0; i <= list_size-1; i++)
	{
		print_token(token_list[i], i);
	}
}

Token *push(int token_type, Token *token_list, int list_size, char *lexeme, int line)
{
	Token new_token;

	new_token.type = token_type;
	new_token.lexeme = lexeme;
	new_token.line = line-1;

	token_list[list_size] = new_token;

	list_size++;

	token_list = (token*)realloc(token_list,(list_size)*sizeof(Token));

	print_token(new_token, list_size);

	return token_list;
}

%}

KEYWORD "type"|"TYPE"|"const"|"CONST"|"var"|"VAR"|"integer"|"INTEGER"|"real"|"REAL"|"array"|"ARRAY"|"of"|"OF"|"record"|"RECORD"|"function"|"FUNCTION"|"procedure"|"PROCEDURE"|"write"|"WRITE"|"read"|"READ"

DIGIT[0-9]
ALPHANUM[a-zA-F0-9]*
ID[a-zA-Z][a-zA-Z0-9]*
WHITESPACE[  \t\r]
COMMENT[^*/]*
STRING[^"\""]*

%%

program|PROGRAM	{
	push(PROGRAMSYM, token_list, list_size, yytext, cursor_line); 	
	fprintf(output,"PROGRAMSYM(%s)", yytext); 	
	list_size++;
}

begin|BEGIN {
	push(BEGINSYM, token_list, list_size, yytext, cursor_line); 	
	fprintf(output,"BEGINSYM(%s)", yytext); 	
	list_size++;
}

end|END {
	push(ENDSYM, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"ENDSYM(%s)", yytext); 		
	list_size++;
}

while|WHILE {
	push(WHILE, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"WHILE(%s)", yytext); 		
	list_size++;
}

else|ELSE {
	push(ELSE, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"ELSE(%s)", yytext); 		
	list_size++;
}

for|FOR {
	push(FOR, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"FOR(%s)", yytext); 			
	list_size++;
}

if|IF {
	push(IF, token_list, list_size, yytext, cursor_line); 			
	fprintf(output,"IF(%s)", yytext); 			
	list_size++;
}

then|THEN {
	push(THEN, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"THEN(%s)", yytext); 		
	list_size++;
}

"+"|"-"|"*"|"/"	{
	push(MATH_OP, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," MATH_OP(%s)", yytext); 	
	list_size++;
}

"<"|">"|"="|"!"	{
	push(LOGICAL_OP, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," LOGICAL_OP(%s)", yytext); 	
	list_size++;
}

":=" {
	push(ASSIGNMENT, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," ASSIGNMENT(%s)", yytext); 	
	list_size++;
}

"."	{
	push(DOT, token_list, list_size, yytext, cursor_line); 		
	fprintf(output," DOT(%s)", yytext);			
	list_size++;
}

","	{
	push(COMMA, token_list, list_size, yytext, cursor_line); 		
	fprintf(output," COMMA(%s)", yytext);		
	list_size++;
}

":"	{
	push(COLON, token_list, list_size, yytext, cursor_line); 		
	fprintf(output," COLON(%s)", yytext);		
	list_size++;
}

";"	{
	push(SEMICOLON, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," SEMICOLON(%s)", yytext);	
	list_size++;
}

"("	{
	push(L_PAREN, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," L_PAREN(%s)", yytext);		
	list_size++;
}

")"	{
	push(R_PAREN, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," R_PAREN(%s)", yytext);		
	list_size++;
}

"["	{
	push(L_BRACKET, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," L_BRACKET(%s)", yytext);	
	list_size++;
}

"]"	{
	push(R_BRACKET, token_list, list_size, yytext, cursor_line); 	
	fprintf(output," R_BRACKET(%s)", yytext);	
	list_size++;
}

{KEYWORD} {
	push(KEYWORD, token_list, list_size, yytext, cursor_line); 	
	fprintf(output,"KEYWORD(%s)", yytext); 		
	list_size++;
}

{DIGIT}+"."{DIGIT}*	{
	push(REAL, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"REAL(%s)", yytext); 		
	list_size++;
}

{DIGIT}+ {
	push(INTEGER, token_list, list_size, yytext, cursor_line); 	
	fprintf(output,"INTEGER(%s)", yytext); 		
	list_size++;
}

{ID}+ {
	push(IDENTIFIER, token_list, list_size, yytext, cursor_line); 	
	fprintf(output,"IDENTIFIER(%s)", yytext); 	
	list_size++;
}

"\""{STRING}"\"" {
	push(CONST_STR, token_list, list_size, yytext, cursor_line); 	
	fprintf(output,"STRING(%s)", yytext);		
	list_size++;
}

"/*"{COMMENT}"*/" {
	fprintf(output,"COMMENT(%s)", yytext);
}

{WHITESPACE} {
	fprintf(output," ");
}

\n {
	fprintf(output,"\n%d ", cursor_line);
	cursor_line++;
}

. {
	push(ERROR, token_list, list_size, yytext, cursor_line); 		
	fprintf(output,"ERROR(%s)", yytext); 		
	list_size++;
}

%%

int yywrap(){return(1);}

int main(int argc, char *argv[])
{ 
	FILE *input;

	token_list = (token*)malloc(sizeof(Token));

	input = fopen(argv[1],"r"); 
	output = fopen("output.txt", "w");

	if(input == NULL)
	{
		printf("input file does not exist.\n");
		return 1;
	}

	yyin = input;
	//yyout = output;

	fprintf(output,"%d ", cursor_line); 

	cursor_line++;
	  
	yylex();

	//print_list(token_list, list_size); 

	fclose(input);
	fclose(output);
	free(token_list);

	return 0; 
} 