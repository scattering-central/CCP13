#include <stdio.h>

int main()
{
  FILE *out_file;
  out_file=fopen("Configure.h","w");

  fprintf(out_file,"%s\n","#ifndef BSL_CONFIGURE");
  fprintf(out_file,"%s\n","#define BSL_CONFIGURE");
  fprintf(out_file,"%s%d\n","#define SIZEOF_CHAR ",sizeof(char));
  fprintf(out_file,"%s%d\n","#define SIZEOF_SHORT ",sizeof(short));
  fprintf(out_file,"%s%d\n","#define SIZEOF_INT ",sizeof(int));
  fprintf(out_file,"%s%d\n","#define SIZEOF_LONG ",sizeof(long));
  fprintf(out_file,"%s%d\n","#define SIZEOF_LONG_LONG ",sizeof(long long));
  fprintf(out_file,"%s%d\n","#define SIZEOF_FLOAT ",sizeof(float));
  fprintf(out_file,"%s%d\n","#define SIZEOF_DOUBLE ",sizeof(double));
  fprintf(out_file,"%s%d\n","#define SIZEOF_LONG_DOUBLE ",sizeof(long double));
  fprintf(out_file,"%s\n","#endif");

  fclose(out_file);
}
