#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <assert.h>
#include <errno.h>
#include "ej1.h"



#define RUN(filename, action) pfile=fopen(filename,"a"); action; fclose(pfile);
#define NL(filename) pfile=fopen(filename,"a"); fprintf(pfile,"\n"); fclose(pfile);

char *filename_ej1 =  "salida.propios.ej1.txt";
msg_t* shuffle(const char* filename, int* len);
void test_ej1(char* filename);


int main() {
	srand(0);
    remove(filename_ej1);
	test_ej1(filename_ej1);
	return 0;
}

#define LINE_LENGHT 80
#define MAX_CHUNK_SIZE 10

msg_t* shuffle(const char* filename, int* len){
    
    FILE* fp;
    fp = fopen(filename, "r");

    char (*line)[LINE_LENGHT+1] = malloc((LINE_LENGHT+1)*MAX_TAGS);
    
    size_t _line_len = 0;
    ssize_t nread;

    for(int i = 0; i < MAX_TAGS; ++i){
        if(fgets(line[i], LINE_LENGHT, fp) == NULL){
            perror("fgets failed");
            fclose(fp);
            free(line);
            return NULL;
        }
    }
    
    fclose(fp);

    FILE *line_stream[MAX_TAGS];
    for(int i=0; i< MAX_TAGS; ++i){
        line_stream[i] = fmemopen(&line[i],strlen(line[i])+1,"r");
    }

    int chunk_size;
    int tag;
    char chunk[MAX_CHUNK_SIZE];
    msg_t* msgArr = malloc(300 * sizeof(msg_t)); 

    int i = 0;
    int finish = 0;
    int readed;
    *len = 0;
    do{
        chunk_size = (rand() % MAX_CHUNK_SIZE) + 1;
        tag = rand() % MAX_TAGS;
        if((readed = fread(chunk,1,chunk_size,line_stream[tag]))){
            msgArr[i].text = malloc(readed + 1);
            strncpy(msgArr[i].text, chunk,readed);

            if(msgArr[i].text[readed - 1] != '\0'){
                msgArr[i].text[readed] = '\0';
            }
            msgArr[i].text_len = strlen(msgArr[i].text);
            msgArr[i].tag = tag;

            //printf("text:%s(%ld)(tag:%d)\n", msgArr[i].text, msgArr[i].text_len, tag);
            
            chunk_size = (rand() % MAX_CHUNK_SIZE) + 1;
            (*len)++;
            i++;
        }
        else{
            finish |= (1 << tag);
        }
    }while(finish != 0xF);
    
    //cleaning
    free(line);
    for(int i=0; i< MAX_TAGS; ++i){
        fclose(line_stream[i]);
    }

    return msgArr;
}

void delete_msgarr(msg_t * msgArr, int len){
    for (int i=0; i<len; ++i){
        free(msgArr[i].text);
    }
    free(msgArr);
}

void delete_groups(char** groups){
    for(int i=0;i<MAX_TAGS;++i){
        free(groups[i]);
    }
    free(groups);
}

void test_ej1(char* filename) {
    
    char** (*func_agrupar)(msg_t* , size_t );
    if (USE_ASM_IMPL){
        func_agrupar = agrupar;
    }else{
        func_agrupar = agrupar_c;
    }

    FILE* pfile;

    RUN(filename, fprintf(pfile, "== Ejercicio 1 ==\n");) NL(filename)

    int len1, len2, len3;
    msg_t *msgArr1 = shuffle("message1.txt", &len1);
    msg_t *msgArr2 = shuffle("message2.txt", &len2);
    msg_t *msgArr3 = shuffle("message3.txt", &len3);

    char **groups1, **groups2, **groups3;
    
    groups1 = func_agrupar(msgArr1, len1);
    groups2 = func_agrupar(msgArr2, len2);
    groups3 = func_agrupar(msgArr3, len3);

    
    RUN(filename, fprintf(pfile, "Message 1\n");) NL(filename)

    for (int i=0; i<MAX_TAGS; ++i){
        RUN(filename, fprintf(pfile, "%s", groups1[i]);)
    }
    NL(filename) NL(filename)

    RUN(filename, fprintf(pfile, "Message 2\n");) NL(filename)

    for (int i=0; i<MAX_TAGS; ++i){
        RUN(filename, fprintf(pfile, "%s", groups2[i]);)
    }
    NL(filename) NL(filename)


    RUN(filename, fprintf(pfile, "Message 3\n");) NL(filename)

    for (int i=0; i<MAX_TAGS; ++i){
        RUN(filename, fprintf(pfile, "%s", groups3[i]);)
    }
    NL(filename) NL(filename)


    delete_msgarr(msgArr1, len1);
    delete_msgarr(msgArr2, len2);
    delete_msgarr(msgArr3, len3);
    delete_groups(groups1);
    delete_groups(groups2);
    delete_groups(groups3);
    
}


