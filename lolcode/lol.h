typedef enum { typeNum, typeYarn, typeFH, typeId, typeOpr } nodeEnum;

/* numbars */
typedef struct {
	int value;				/* value of constant */
} numNodeType;

/* yarns */
typedef struct {
	char * value;			/* value of constant */
} yarnNodeType;

/* file handles */
typedef struct {
	FILE * value;			/* value of constant */
} FHNodeType;


/* identifiers */
typedef struct {
	int i;					/* subscript to sym array */
} idNodeType;

/* operators */
typedef struct {
	int oper;					/* operator */
	int nops;					/* number of operands */
	struct nodeTypeTag *op[1];	/* operands (expandable) */
} oprNodeType;

typedef struct nodeTypeTag {
	nodeEnum type;			/* type of node */

	/* union must be last entry in nodeType */
	/* because operNodeType may dynamically increase */
	union {
		numNodeType num;		/* numbars */
		yarnNodeType yarn;		/* yarns */
		FHNodeType FH;			/* file handles */
		idNodeType id;			/* identifiers */
		oprNodeType opr;		/* operators */
	};
} nodeType;

extern int sym[26];
extern int symtype[26];
extern char * yarnz[26];
extern int inloop;
