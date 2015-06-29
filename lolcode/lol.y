%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "lol.h"
#define YYERROR_VERBOSE

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *num(int value);
nodeType *yarn(char * value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);

void yyerror(char *s);
int sym[26];		/* numbar table */
int symtype[26];	/* symbol types */
char * yarnz[26];	/* yarn table */
int inloop;
%}

%union {
	int iValue;	/* integer value */
	char sIndex;	/* symbol table index */
	char *sValue;	/* yarn value */
	nodeType *nPtr;	 /* node pointer */
};

%token <iValue> NUMBAR
%token <sIndex> VARIABLE
%token <sValue> YARN
%token IZ VISIBLE KTHXBYE HAI HASSTDIO INLOOP UPZ NERFZ OVARZ TIEMZD HAS ITZ HASITZ GTFO VISIBLENB LOL YARLY KTHX EOS NOWAI R WORD LETTAR LINE GIMMEH OUTTA
%nonassoc IFX


%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%left '!'
%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list

%expect 24

%%

program:
	function	{ exit(0); }
	;

function:
	  function stmt	{ ex($2); freeNode($2); }
	| /* NULL */
	;

stmt:
	  EOS				{ $$ = opr(';', 2, NULL, NULL); }
	| expr EOS			{ $$ = $1; }
	| VISIBLE expr '!'		{ $$ = opr(VISIBLENB, 1, $2); }
	| VISIBLE expr 			{ $$ = opr(VISIBLE, 1, $2); }
	| LOL VARIABLE R expr		{ $$ = opr('=', 2, id($2), $4); }
	| IZ expr '?' stmt_list KTHX %prec IFX	{ $$ = opr(IZ, 2, $2, $4); }
	| IZ expr '?' stmt_list NOWAI stmt_list KTHX	{ $$ = opr(IZ, 3, $2, $4, $6); }
	| IZ expr '?' YARLY stmt_list KTHX %prec IFX	{ $$ = opr(IZ, 2, $2, $5); }
	| IZ expr '?' YARLY stmt_list NOWAI stmt_list KTHX	{ $$ = opr(IZ, 3, $2, $5, $7); }
	| KTHXBYE expr expr		{ $$ = opr(KTHXBYE, 2, $2, $3) ; }
	| KTHXBYE expr			{ $$ = opr(KTHXBYE, 1, $2) ; }
	| KTHXBYE 			{ $$ = opr(KTHXBYE, 1, num(0)); }
	| HASSTDIO '?'			{ $$ = opr(HASSTDIO, 0); }
	| GTFO				{ $$ = opr(GTFO, 0); }
	| HAI				{ $$ = opr(HAI, 0); }
	| INLOOP stmt_list KTHX		{ $$ = opr(INLOOP, 1, $2); }
	| UPZ VARIABLE '!' '!' 		{ $$ = opr(UPZ, 2, id($2), num(1)); }
	| UPZ VARIABLE '!' '!' expr	{ $$ = opr(UPZ, 2, id($2), $5); }
	| NERFZ VARIABLE '!' '!'	{ $$ = opr(NERFZ, 2, id($2), num(1)); }
	| NERFZ VARIABLE '!' '!' expr	{ $$ = opr(NERFZ, 2, id($2), $5); }
	| OVARZ VARIABLE '!' '!'	{ $$ = opr(OVARZ, 2, id($2), num(1)); }
	| OVARZ VARIABLE '!' '!' expr	{ $$ = opr(OVARZ, 2, id($2), $5); }
	| TIEMZD VARIABLE '!' '!'	{ $$ = opr(TIEMZD, 2, id($2), num(1)); }
	| TIEMZD VARIABLE '!' '!' expr	{ $$ = opr(TIEMZD, 2, id($2), $5); }
	| HAS VARIABLE ITZ expr		{ $$ = opr('=', 2, id($2), $4); }
	| HAS VARIABLE			{ $$ = opr(HAS, 1, id($2)); }
	| GIMMEH VARIABLE		{ $$ = opr(GIMMEH, 1, id($2)); }
	| GIMMEH LINE VARIABLE		{ $$ = opr(GIMMEH, 1, id($3)); }
	| GIMMEH LETTAR VARIABLE	{ $$ = opr(LETTAR, 1, id($3)); }
	| GIMMEH WORD VARIABLE		{ $$ = opr(WORD, 1, id($3)); }
	| GIMMEH VARIABLE OUTTA VARIABLE	{ $$ = opr(GIMMEH, 2, id($2), id($4)); }
	| GIMMEH LINE VARIABLE OUTTA VARIABLE	{ $$ = opr(GIMMEH, 2, id($3), id($5)); }
	| GIMMEH LETTAR VARIABLE OUTTA VARIABLE	{ $$ = opr(LETTAR, 2, id($3), id($5)); }
	| GIMMEH WORD VARIABLE OUTTA VARIABLE	{ $$ = opr(WORD, 2, id($3), id($5)); }
		;

stmt_list:
		  stmt			{ $$ = $1; }
		| stmt_list stmt	{ $$ = opr('\n', 2, $1, $2); }
		;

expr:
	  NUMBAR		{ $$ = num($1); }
	| VARIABLE		{ $$ = id($1); }
	| YARN			{ $$ = yarn($1); }
/*	| '-' expr %prec UMINUS	{ $$ = opr(UMINUS, 1, $2); } - the unary minus causes ambiguity in the grammar, and isn't implemented yet anyway. */
	| expr '+' expr		{ $$ = opr('+', 2, $1, $3); }
	| expr '-' expr		{ $$ = opr('-', 2, $1, $3); }
	| expr '*' expr		{ $$ = opr('*', 2, $1, $3); }
	| expr '/' expr		{ $$ = opr('/', 2, $1, $3); }
	| expr '<' expr		{ $$ = opr('<', 2, $1, $3); }
	| expr '>' expr		{ $$ = opr('>', 2, $1, $3); }
	| expr GE expr		{ $$ = opr(GE, 2, $1, $3); }
	| expr LE expr		{ $$ = opr(LE, 2, $1, $3); }
	| expr NE expr		{ $$ = opr(NE, 2, $1, $3); }
	| expr EQ expr		{ $$ = opr(EQ, 2, $1, $3); }
	| '(' expr ')'		{ $$ = $2; }
	;

%%

#define SIZEOF_NODETYPE ((char *)&p->num - (char *)p)

/* numbar node */
nodeType *num(int value) {
	nodeType *p;
	size_t nodeSize;

	/* allocate node */
	nodeSize = SIZEOF_NODETYPE + sizeof(numNodeType);
	if ((p = malloc(nodeSize)) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeNum;
	p->num.value = value;

	return p;
}

/* yarn node */
nodeType *yarn(char * value) {
	nodeType *p;
	size_t nodeSize;

	/* allocate node */
	nodeSize = SIZEOF_NODETYPE + sizeof(yarnNodeType);
	if ((p = malloc(nodeSize)) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeYarn;
	p->yarn.value = value;

	return p;
}


/* variable node */
nodeType *id(int i) {
	nodeType *p;
	size_t nodeSize;

	/* allocate node */
	nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
	if ((p = malloc(nodeSize)) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeId;
	p->id.i = i;

	return p;
}

/* operation node */
nodeType *opr(int oper, int nops, ...) {
	va_list ap;
	nodeType *p;
	size_t nodeSize;
	int i;

	/* allocate node */
	nodeSize = SIZEOF_NODETYPE + sizeof(oprNodeType) +
		(nops - 1) * sizeof(nodeType*);
	if ((p = malloc(nodeSize)) == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = typeOpr;
	p->opr.oper = oper;
	p->opr.nops = nops;
	va_start(ap, nops);
	for (i = 0; i < nops; i++)
		p->opr.op[i] = va_arg(ap, nodeType*);
	va_end(ap);
	return p;
}

void freeNode(nodeType *p) {
	int i;

	if (!p) return;
	if (p->type == typeOpr) {
		for (i = 0; i < p->opr.nops; i++)
			freeNode(p->opr.op[i]);
	}
	free (p);
}

void yyerror(char *s) {
	fprintf(stdout, "yyerror: %s\n", s);
}

int main(void) {
	int i;
	for (i = 0; i < 26 ; i++) yarnz[i] = (char *)NULL;
	yyparse();
	return 0;
}
