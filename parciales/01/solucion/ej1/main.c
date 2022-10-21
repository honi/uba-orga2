#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ej1.h"

int main (void){
	msg_t msg1 = {"Hola ", 5, 0};
	msg_t msg2 = {"Chau", 4, 1};
	msg_t msg3 = {"mundo!", 6, 0};
	msg_t msgs[] = {msg1, msg2, msg3};

	char **res = agrupar(msgs, 3);
	for (int i = 0; i < MAX_TAGS; i++) {
		printf("tag #%d: %s\n", i, res[i]);
		free(res[i]);
	}
	free(res);

	return 0;
}
