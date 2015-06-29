#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lol.h"
#include "y.tab.h"

int ex(nodeType *p) {
	char * line = NULL;
	char linebuffar[16384];
	size_t len = 0;
	ssize_t read;

	if (!p) return 0;
	switch(p->type) {
	case typeNum:		return p->num.value;
	case typeId:		return sym[p->id.i];
	case typeOpr:
		switch(p->opr.oper) {
		case IZ:		if (ex(p->opr.op[0]))
							ex(p->opr.op[1]);
						else if (p->opr.nops > 2)
							ex(p->opr.op[2]);
						return 0;
		case VISIBLE:	if (p->opr.op[0]->type == typeYarn)
							printf("%s\n", p->opr.op[0]->yarn.value);
						else if (p->opr.op[0]->type == typeId && symtype[p->opr.op[0]->id.i] == typeYarn)
							printf("%s\n", yarnz[p->opr.op[0]->id.i]);
						else
							printf("%d\n", ex(p->opr.op[0]));
						return 0;

		case VISIBLENB:	if (p->opr.op[0]->type == typeYarn)
							printf("%s", p->opr.op[0]->yarn.value);
						else if (p->opr.op[0]->type == typeId && symtype[p->opr.op[0]->id.i] == typeYarn)
							printf("%s", yarnz[p->opr.op[0]->id.i]);
						else
							printf("%d", ex(p->opr.op[0]));
						return 0;

		case '\n':		ex(p->opr.op[0]); return ex(p->opr.op[1]);
		case '=':		if (p->opr.op[1]->type == typeYarn) {
							symtype[p->opr.op[0]->id.i] = typeYarn;
							/*if (yarnz[p->opr.op[0]->id.i] != (char *)NULL)
								free(yarnz[p->opr.op[0]->id.i]);*/
							yarnz[p->opr.op[0]->id.i] = malloc(strlen(p->opr.op[1]->yarn.value) * sizeof(char));
							strcpy(yarnz[p->opr.op[0]->id.i],p->opr.op[1]->yarn.value);
							
							return 0; 
						} else {
							symtype[p->opr.op[0]->id.i] = typeNum;
							return sym[p->opr.op[0]->id.i] = ex(p->opr.op[1]);
						}
		case UMINUS:	return -ex(p->opr.op[0]);
		case '+':		return ex(p->opr.op[0]) + ex(p->opr.op[1]);
		case '-':		return ex(p->opr.op[0]) - ex(p->opr.op[1]);
		case '*':		return ex(p->opr.op[0]) * ex(p->opr.op[1]);
		case '/':		return ex(p->opr.op[0]) / ex(p->opr.op[1]);
		case '<':		return ex(p->opr.op[0]) < ex(p->opr.op[1]);
		case '>':		return ex(p->opr.op[0]) > ex(p->opr.op[1]);
		case GE:		return ex(p->opr.op[0]) >= ex(p->opr.op[1]);
		case LE:		return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
		case NE:		return ex(p->opr.op[0]) != ex(p->opr.op[1]);
		case EQ:		return ex(p->opr.op[0]) == ex(p->opr.op[1]);
		case GTFO:		return inloop = 0;
		case KTHXBYE:	if (p->opr.nops > 1)
							printf("%s\n", p->opr.op[1]->yarn.value);
						exit(ex(p->opr.op[0]));
		case HAI:		return 0;
		case HASSTDIO:	return 0;
		case INLOOP:	inloop = 1; while (inloop) ex(p->opr.op[0]); inloop = 1; return 0;
		case UPZ:		return sym[p->opr.op[0]->id.i] = ex(p->opr.op[0]) + ex(p->opr.op[1]);
		case NERFZ:		return sym[p->opr.op[0]->id.i] = ex(p->opr.op[0]) - ex(p->opr.op[1]);
		case TIEMZD:	return sym[p->opr.op[0]->id.i] = ex(p->opr.op[0]) * ex(p->opr.op[1]);
		case OVARZ:		return sym[p->opr.op[0]->id.i] = ex(p->opr.op[0]) / ex(p->opr.op[1]);
		case HAS:		return sym[p->opr.op[0]->id.i] = 0;
		case GIMMEH:	if (p->opr.nops == 1) {
							/* first, take care of stdin cases */
							fgets(linebuffar, 16384, stdin);
							printf ("Line entered: %s\n", linebuffar);
							symtype[p->opr.op[0]->id.i] = typeYarn;
							/*if (yarnz[p->opr.op[0]->id.i] != (char *)NULL)
								free(yarnz[p->opr.op[0]->id.i]);*/
							yarnz[p->opr.op[0]->id.i] = malloc(strlen(linebuffar) * sizeof(char));
							strcpy(yarnz[p->opr.op[0]->id.i],linebuffar);
							printf ("Line copied: %s\n", yarnz[p->opr.op[0]->id.i]);
						}
						return 0; 
/*		case LETTAR:
		case WORD:*/
		}
	}
	return 0;
}
