%{
	#include "windows.h"
	#include <iostream>
	#include <string>
	using namespace std;
	#define _CRT_SECURE_NO_WARNINGS
%}

%option noyywrap
%option never-interactive
%option 8bit

%x STR_ERR

NAME_CHAR [A-Za-z_]|\xD0[\x81\x90-\xBF]|\xD1[\x91\x80-\x8F]

%%

"алг" cout << "Found algorithm" << endl;
"дано" cout << "Found algorithm conditions" << endl;
"надо" cout << "Found algorithm objective" << endl;
"нач" cout << "Found algorithm begin" << endl;
"кон" cout << "Found algorithm end" << endl;
"арг" cout << "Found input parameter" << endl;
"рез" cout << "Found output parameter" << endl;
"аргрез" cout << "Found input-output parameter" << endl;
"знач" cout << "Found function result" << endl;
"исп" cout << "Found using" << endl;
"утв" cout << "Found algorithm continuation condition" << endl;

"нц" cout << "Found loop begin" << endl;
"кц" cout << "Found loop end" << endl;
"раз" cout << "Found loop count" << endl;
"пока" cout << "Found loop condition" << endl;
"для" cout << "Found loop initialization" << endl;
"от" cout << "Found loop range min value" << endl;
"до" cout << "Found loop range max value" << endl;

"если" cout << "Found IF statement" << endl;
"то" cout << "Found THEN statement" << endl;
"иначе" cout << "Found ELSE statement" << endl;
"выбор" cout << "Found SWITCH statement" << endl;
"при" cout << "Found CASE statement" << endl;
"все" cout << "Found branching end" << endl;

"цел" {
	cout << "Found int" << endl;
}
"вещ" {
	cout << "Found float" << endl;
}
"лог" {
	cout << "Found bool" << endl;
}
"сим" {
	cout << "Found char" << endl;
}
"лит" {
	cout << "Found string" << endl;
}
"таб" cout << "Found array" << endl;

\-?[0-9]+ {
	string str = string(yytext);
	cout << "Found integer constant: " << stoi(str) << endl;
}

\$[0-9A-Fa-f]+ {
	string str = string(yytext + 1);
	cout << "Found hex integer constant: " << stoi(str, 0, 16) << endl;
}

"-"?[0-9]+(\.[0-9]+)?((e|E|е|Е)[+-]?[0-9]+)? cout << "Found float constant: " << stof(yytext) << endl;
"да" cout << "Found bool TRUE constant" << endl;
"нет" cout << "Found bool FALSE constant" << endl;
(\".\")|('.') {
	string str = string(yytext);
	cout << "Found char constant: " << str[1] << endl;
}
(\".*?\")|('.*?') {
	string str = string(yytext);
	cout << "Found string constant: " << str.substr(1, str.size() - 2) << endl;
}
('|\") BEGIN(STR_ERR);

<STR_ERR>.* {
	cout << "Found missing terminating quotation mark error: " << yytext + 1 << endl;
	BEGIN(INITIAL);
}

":=" cout << "Found assignment operation" << endl;
"+" cout << "Found addition operation" << endl;
"-" cout << "Found subtraction operation" << endl;
"*" cout << "Found multiplication operation" << endl;
"/" cout << "Found division operation" << endl;
"**" cout << "Found exponentiation operation" << endl;
"=" cout << "Found EQUALS operation" << endl;
"<>" cout << "Found NOT EQUALS operation" << endl;
">" cout << "Found MORE operation" << endl;
"<" cout << "Found LESS operation" << endl;
">=" cout << "Found MORE OR EQUAL operation" << endl;
"<=" cout << "Found LESS OR EQUAL operation" << endl;
"и" cout << "Found AND operation" << endl;
"или" cout << "Found OR operation" << endl;
"не" cout << "Found NOT operation" << endl;

"[" cout << "Found opening bracket" << endl;
"]" cout << "Found closing bracket" << endl;
":" cout << "Found colon" << endl;
"," cout << "Found comma" << endl;
"(" cout << "Found opening parenthesis" << endl;
")" cout << "Found closing parenthesis" << endl;
";" cout << "Found semicolon" << endl;

"ввод" cout << "Found input" << endl;
"вывод" cout << "Found output" << endl;
"нс" cout << "Found string new line" << endl;
"|".*$ cout << "Found comment: " << yytext + 1 << endl;
#.*$ cout << "Found algorithm comment: " << yytext + 1 << endl;

{NAME_CHAR}({NAME_CHAR}|[0-9])* cout << "Found name: " << yytext << endl;

\n|";" cout << "Found new line" << endl;

(" "|\t)+

%%

int main( int argc, char **argv ) {
	SetConsoleCP(CP_UTF8);
	SetConsoleOutputCP(CP_UTF8);
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 ) {
            yyin = fopen( argv[0], "r" );
    } else {
            yyin = stdin;
    }
    yylex();
}