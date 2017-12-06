struct node;
void printnode(struct node *thenode);
int nodecmp(struct node *node1, struct node *node2);
struct node *lookup(char *s);
struct node *push(char *lex, int defaultcode);
struct node *setnode(char *lex, float val, int defaultcode);
struct node *getnode(char *lex);
struct node *pop(char *s);

