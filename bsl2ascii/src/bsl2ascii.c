#include <stdio.h>
#include <string.h>
#include <stdlib.h>  
#include <sys/types.h>  
#include <sys/stat.h>  
#include <unistd.h>  
#include <math.h>  

#define BFR_SZ 100 /* BSL spec says lines must be no longer than 80 chars */
#define NUM_INDICATORS 10
#define CSV_EXTENSION ".txt" 

typedef struct __bin_file
  {
  struct __bin_file *nxt; /* nxt ptr for ll use */
  int file_idx; /* for storing the idx of file - i.e., first one = 0 */
  char *filename;
  char *header_filename; /* for storing header filename */
  int pixels;   /* width of x-scale */
  int rasters;  /* width of y-scale */
  int frames;   /* number of times frames /*
  
  /* These indicators are specified under BSL but are unused (yet) */
  int ind_4;
  int ind_5;
  int ind_6;
  int ind_7;
  int ind_8;
  int ind_9;

  /* This next one is used to determine whether or not file is last
     in binary file list - 0 if it is and '1' if not */
  int ind_10;
  
  /* The first two lines of BSL header file are comments for users - 
     we might as well save them - you never know they might be useful */
  char *first_line;
  char *second_line;  
  }BIN_FILE;   

BIN_FILE *pHead = NULL; /* This is head of bin-file ll */ 

void * mymalloc (int sz); 

int check_frame_size(int frame_sz)
  {
  /* frame size needs to be divisible by sizeof(float)  */
  return (!(frame_sz % sizeof(float)));
  } 

void close_files (FILE *in, FILE *out)
  {
  fclose(in);
  fclose(out);
  }

void process_file (BIN_FILE * rec)
  {
  /* accepts ptr to BIN_FILE and creates a .csv file to go with it */  
  FILE *in,*out;
  char *output_ptr,*ptr,*csv_file,*bfr,*tmp; 
  int thing,j,i, frame_sz,remainder,read_sz; 
  float *fl;  
  tmp = mymalloc(1000); 

  /* NEVER change the call below to "r" - you absolutely need
     the "rb" for porting to DOS (which hates the "r").  */
  in = fopen(rec->filename, "rb");

  if (in == (FILE *) NULL)
    {
    fprintf(stderr,"Problem opening file %s for reading.\n",rec->filename); 
    exit(0);
    }

  csv_file = (char *)mymalloc(strlen(rec->filename)+strlen(CSV_EXTENSION)+1);
  strcpy(csv_file,rec->filename);
  strcat(csv_file,CSV_EXTENSION); 

  out = fopen(csv_file, "w");

  if (out == (FILE *) NULL)
    {
    fprintf(stderr,"Problem opening file %s for writing.\n",csv_file); 
    close_files(in,out);
    exit(0);
    }
  
  /* Now create buffer of one frame size. */
  frame_sz = sizeof(float)*rec->rasters*rec->pixels;
  bfr = (char *) mymalloc ( frame_sz); 
  memset(tmp,1000,'\0'); 

/*  printf("frame size is %d\n",frame_sz);
  printf("there are  %d frames \n",rec->frames);
 */
 
  for (i = 0; i < rec->frames; ++i)
    {
    /* Loop over each frame stick contents into bfr. */ 
    char *output;  

    output = (char *) malloc (20*rec->rasters*rec->pixels);
    if (output == (char *) NULL)
      {
      fprintf(stderr,"Out of memory.\n");  
      close_files(in,out);
      exit(0);
      }
    read_sz = fread(bfr,frame_sz - 1,1,in); 
    if (1 == read_sz) 
      {
      /* Success - now process bfr. */
      int ras_counter,pixel_counter; 
      ptr =  bfr;
      
      for (ras_counter = 0; ras_counter < rec->rasters; ++ras_counter)
        {
        for (pixel_counter = 0; pixel_counter < rec->pixels; ++pixel_counter)
          {
          fl = (float *) ptr; 
          ptr += sizeof(float);    
        
          if (pixel_counter == (rec->pixels - 1) )
            sprintf(tmp,"%f\n",*fl);
          else 
            sprintf(tmp,"%f\n",*fl);
          fprintf(out,tmp);
          }
        } 
     /* fprintf(out,"\n***End of Frame***\n");
      */
      free(output);
      fflush(out);
      }
    else
      {
      fprintf(stderr,"Failed to read from file %s.\n",rec->filename);
      close_files(in,out);
      return;
      }
    }
  close_files(in,out);
  }

void process_bin_file_ll (BIN_FILE *head)
  {
  /* Procedure accepts ptr to head node of bin-file list and will process
     each one in turn. */
  BIN_FILE *search = head;  
  
  while (search != (BIN_FILE *) NULL)  
    {
    process_file (search);
    search = search->nxt;
    }
  }

int check_file_sizes_match (BIN_FILE * rec)
  {
  /* This verifies that the size of binary file is reflected in the
     values of pixels,rasters and frames mentioned in header file. */
  long file_sz; 
  struct stat buf;

  file_sz = (long) sizeof(float)*rec->pixels * rec->rasters * rec->frames;
  if (-1 == stat(rec->filename,&buf))  
    {
    fprintf(stderr,"File \'%s\' does not exist.\n",rec->filename); 
    return 0;
    }

  if (buf.st_size !=  file_sz)
    {
    fprintf(stderr,
    "\nMismatched file sizes for \'%s\':\n",rec->filename);  
    fprintf(stderr,
    "\t- actual size = %d bytes, header file says size = %d\n\n",
            buf.st_size, file_sz);  
    return (buf.st_size > file_sz) ; 
    }
  return 1;
  }

void * mymalloc (int sz)
  {
  /* This is a local version of malloc - handles malloc failure by
     quitting programme. */
  int * rtn = (int *) malloc (sz);

  if (rtn == (int *) NULL)
    {
    fprintf(stderr,
     "Memory allocation failure - out of memory?\n"); 
    exit(0);
    }
  
  return rtn;
  }

int * get_last_node_with_offset (void *head, int offset)
  {
  int *ret=(int*)head,*ptr = (int *) head;

  while (ptr )
    {
    ret = ptr;
    ptr = (int *)*((int *) ((int)ptr + offset));
    }
  return ret;
  }

BIN_FILE * get_node_by_idx (BIN_FILE *head, int idx)
  {
  BIN_FILE *search = head;

  while (search != (BIN_FILE *) NULL)  
    {
    if (search->file_idx == idx)
      return search;
    else
      search = search->nxt;
    }

  return NULL;
  }

void check_ll_integrity (BIN_FILE *head)
  {
  BIN_FILE *search = head;

  while (search != (BIN_FILE *) NULL)  
    {
    if (search->filename  == NULL)
      {
      fprintf(stderr,"There is a mismatch between number of header data ");
      fprintf(stderr,
      "lines and number of filenames - can't continue.\n");
      exit(0);
      }    
    search = search->nxt;
    }
  }

void append_ll (void *head, void *rec, int offset)
  {
  int *deref2, deref, *lrec=(int*)rec, *ptr, **lhead = (int **) head;
  ptr = (int *)get_last_node_with_offset( *lhead,offset);
 
  if (!ptr)
    {
    /* we're adding first node */
    deref2 = (int *)((int)lrec + offset);
    *deref2 = 0;
    *lhead = lrec;
    return ;
    }

  deref2 = (int *)((int)ptr + offset);
  *deref2 = (int) lrec;
  }

void get_bin_file_list (char * header_filename) 
  {
  /* This procedure accepts the name of a BSL header file and returns
     a pointer to a linked list of the referenced binary files -
     the first file in list will be first bin file referenced by header
     file, and so forth. */
  int loop_idx,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i,j,hdr_data_lines;
  int i11,i12,i13,i14,i15,i16,i17,i18,i19,i20;
  BIN_FILE *bf;
  FILE *hdrfp;
  char *first_line,*second_line;
  char bfr[BFR_SZ];  

  loop_idx = 0; 
  hdrfp = fopen(header_filename,"r");   
  
  if (hdrfp == NULL)
    {
    /* file pointer is null - we have failed to open header file. */
    fprintf(stderr,"Have failed to open %s - does it exist?\n",
                 header_filename);  
    exit(0);
    }

  /* Opened header file okay - now process it */

  /* Get first line of header file. */
  first_line = (char *)mymalloc(BFR_SZ*sizeof(char));
  fgets(first_line,BFR_SZ,hdrfp);
  /* Get second line of header file. */
  second_line = (char *) mymalloc (BFR_SZ*sizeof(char)); 
  fgets(second_line,BFR_SZ,hdrfp);
  while (1)
    {
    if (NUM_INDICATORS == fscanf(hdrfp,"%d %d %d %d %d %d %d %d %d %d\n",
      &i1,&i2,&i3,&i4,&i5,&i6,&i7,&i8,&i9,&i10) )  
      {
      BIN_FILE *bf;
      bf = (BIN_FILE *) mymalloc (sizeof(struct __bin_file)); 
      memset(bf,sizeof(struct __bin_file),'\0'); /* set whole block to NULLs */
      bf->header_filename = header_filename;
      bf->first_line = first_line;
      bf->second_line  = second_line;
      bf->file_idx = loop_idx++;
      bf->pixels = i1;   
      bf->rasters = i2;
      bf->frames = i3; 
      bf->ind_4 = i4; 
      bf->ind_5 = i5; 
      bf->ind_6 = i6; 
      bf->ind_7 = i7; 
      bf->ind_8 = i8; 
      bf->ind_9 = i9; 
      bf->ind_10 = i10; 

      if (1 == fscanf(hdrfp,"%s",&bfr))
        {
        /* Success - we have filename of binary whose data we just obtained. */
        char *buffer;
        buffer = (char *) mymalloc(BFR_SZ * sizeof(char));   

        strcpy(buffer,bfr);
        bf->filename = buffer;
        if (!bf->ind_10 )
          /* This is last file according to BSL rules. */ 
          {
          append_ll(&pHead, bf, (int)&bf->nxt - (int)bf);
          break; 
          }
        }
      else
        {
        /* Failed to get filename for previous file data. */
        fprintf(stderr,
          "There is a line of binary file data without a following filename."); 
        break; 
        }
 
      append_ll(&pHead, bf, (int)&bf->nxt - (int)bf);
      }
    else  
      {
      /* No data lines left? Time to get out. */
      break;
      }
    }

 /* Should have processed all filename lines now and have a correctly
    set-up ll  - let's run a check and see... */
 check_ll_integrity(pHead);   
 check_file_sizes_match(pHead); 
 process_bin_file_ll (pHead);  
 }

int main (int argc, char **argv)
  {
  char * header_filename;
  char * this_prog = argv[0];

  if ((argv[1] == NULL) || (!strlen((const char *) argv[1]) ))
    {
    printf(
       "\n\tYou need to supply the name of a header file as an argument.\n"); 
    printf("\n\t\t%s filename\n\n",this_prog);    
    exit(0);
    }  

  header_filename = argv[1];

  /* Got header file name now */
  get_bin_file_list (header_filename);
  } 

