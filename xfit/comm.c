#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <wait.h>

#define FALSE 0
#define TRUE !FALSE
#define BUFSIZE 200

/*
 * The system call pipe() returns an array of 2
 * integers, which contain the file descriptors
 * of each end of the pipe. Element 0 is the read
 * descriptor and element 1 is the write descriptor
 * In this routine, they are placed in the variables
 *
 * fdin[0]  - Parent reads  data from child
 * fdin[1]  - Child  writes data to   parent
 * fdout[0] - Child  reads  data from parent
 * fdout[1] - Parent writes data to   child.
 *
 * Parent and child close the unwanted descriptors
 * after the fork. (Parent closes fdin[1] and 
 * fdout[0], and child closes fdin[0] and fdout[1]).
 *
 * In the child process, the descriptors are reconnected
 * to stdin and stdout (file descriptors 0 and 1).
 * This is achieved by:   close(0), dup(fdout[0]), close(fdout[0]);
 *
 * As the dup copies the descriptor to the lowest unused 
 * descriptor, in this case 0 after the close. The dup'ed
 * descriptor is then close'd for tidiness. A similar procedure
 * is adopted for stdout (1).
 *
 * In the parent process, file streams are associated with the
 * pipe descriptors, by means of fdopen(). These streams
 * are called CommIn, and CommOut
 */

int  XGinit (char *);
void XGclose ();
void XGputstring (char *);

static FILE *CommIn, *CommOut;
static int initialised = FALSE;
static int pid;

int XGinit (char *prog)
{
    int fdin[2], fdout[2];
    char *argv[2];

    if ((pipe (fdin)  == -1) ||
	(pipe (fdout) == -1))
      {
	fprintf (stderr, "Could not open pipes\n");
	exit (0);
      }

    switch ((pid = fork ()))
    {
        case 0:
	    close (0);
	    dup (fdout[0]);
	    close (fdout[0]);
	    close (fdout[1]); 
	    
	    close (1);
	    dup (fdin[1]);
	    close (fdin[1]);
	    close (fdin[0]); 

	    argv[0] = prog;
	    argv[1] = (char *) NULL;
	    
	    execvp (prog, argv);
	    perror ("fork");
	    fprintf (stderr,"Could not exec driver program\n");
	    _exit (0);

	case -1:
	    fprintf (stderr,"Could not fork driver program\n");
	    exit (0);

	default:
	    fcntl (fdout[1], F_SETFL, O_WRONLY | O_NONBLOCK);
	    CommOut = fdopen (fdout[1],"w"); 
	    close (fdout[0]); 

	    fcntl (fdin[0], F_SETFL, O_RDONLY | O_NONBLOCK);
	    CommIn = fdopen (fdin[0],"r");
	    close (fdin[1]); 

	    initialised = TRUE;
	    return (fdin[0]);
    }
}

void XGclose ()
{
    siginfo_t info;
    if (initialised)
    {
        waitid (P_PID, pid, &info, WEXITED);
	fclose (CommOut);
	fclose (CommIn);
	initialised = FALSE;
    }
}

void XGputstring (char *string)
{
    if (initialised)
    {
        fprintf (CommOut, "%s", string);
	fflush (CommOut);
    }
    else
    {
        fprintf (stderr, "Could not write string - I/O not initialised\n");
        return;
    }

    return;
}






