%{
#include <stdlib.h>
#include "lol.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%

BTW[^\n.]*[\n.]	; /* ignore comments */

[0-9]+	{
		yylval.iValue = atoi(yytext);
		return NUMBAR;
	}

\"[^\"]*\"	{
			yylval.sValue = malloc(strlen(yytext) * sizeof(char));
			strncpy(yylval.sValue, yytext+1,strlen(yytext)-2);
			return YARN;
		}


[\n.]	; /* ignore EOS */

[?!]	{
		return *yytext;
	}

"SMALR THAN"		return '<';
"BIGR THAN"		return '>';
"NOT SMALR THAN"	return GE;
"NOT BIGR THAN"		return LE;
"LIEK"			return EQ;
"NOT LIEK"		return NE;
"IZ"			return IZ;
"NOWAI"			return NOWAI;
"YARLY"			return YARLY;
"VISIBLE"		return VISIBLE;
"KTHXBYE"		return KTHXBYE;
"BYES"			return KTHXBYE;
"DIAF"			return KTHXBYE;
"GTFO"			return GTFO;
"HAI"			return HAI;
"CAN HAS STDIO"		return HASSTDIO;
"IM IN YR LOOP"		return INLOOP;
"IM OUT OF YR LOOP"	return KTHX;
"KTHX"			return KTHX;
"UPZ"			return UPZ;
"NERFZ"			return NERFZ;
"TIEMZD"		return TIEMZD;
"OVARZ"			return OVARZ;
"I HAS A"		return HAS;
"ITZ"			return ITZ;
"NERF"			return '-';
"TIEMZ"			return '*';
"OVAR"			return '/';
"LOL"			return LOL;
"R"			return R;
"LINE"			return LINE;
"WORD"			return WORD;
"LETTAR"		return LETTAR;
"GIMMEH"		return GIMMEH;
"OUTTA"			return OUTTA;

[A-Z]+	{
		yylval.sIndex = *yytext - 'A';
		return VARIABLE;
	}

[ \t\r]+	;	/* ignore whitespace */

.		yyerror("Unknown character");
%%
int yywrap(void) {
	return 1;
}
