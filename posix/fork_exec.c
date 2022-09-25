#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
    pid_t pid = fork();
    if (pid == -1) {
        printf("error:fork failed!\n");
        return -1;
    }
    else if (pid == 0) {
        char *x = NULL;
        char *argv[] = {"/home/ig/test", NULL};
        int ret = execve("/home/ig/test", argv, &x);
        if (ret != 0)
            fprintf(stderr, "exec failed!\n");
        else {
            fprintf(stderr, "exec return!\n");
            ret = -1;
        }
        return ret;
    }
    int statval;
    wait(&statval);
    if (WIFEXITED(statval) && WEXITSTATUS(statval) == 0)
        printf("子进程执行成功！%d\n", statval);
    else
        printf("子进程执行失败！%d\n", statval);
    return 0;
}
