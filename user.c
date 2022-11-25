#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mount.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>

#define STACK_SIZE (1024 * 1024)

static char container_stack[STACK_SIZE];
char* const container_args[] = {
    "/bin/bash",
    NULL
};

char* const container_envp[] = {
    "PATH=/bin",
    "TERM=console",
    "HOME=/root",
    NULL
};

void set_groups(char* file, char* value) {
    FILE* groupfd = fopen(file, "w");
    if (NULL == groupfd) {
        perror("open file error");
        return;
    }
    fprintf(groupfd, "%s", value);
    fclose(groupfd);
}
void set_map(char* file, int inside_id, int outside_id, int len) {
    FILE* mapfd = fopen(file, "w");
    if (NULL == mapfd) {
        perror("open file error");
        return;
    }
    fprintf(mapfd, "%d %d %d", inside_id, outside_id, len);
    fclose(mapfd);
}

int container_main(void* arg)
{

    printf("Container [%5d] - inside the container!\n", getpid());

    printf("Container: eUID = %ld; eGID = %ld, UID=%ld, GID=%ld\n",
           (long) geteuid(), (long) getegid(), (long) getuid(), (long) getgid());

    printf("Container [%5d] - setup hostname!\n", getpid());
    //set hostname
    sethostname("container",10);

    //set root directory
    chroot("rootfs");

    //change to `/`
    chdir("/");

    //remount "/proc" to make sure the "top" and "ps" show container's information
    mount("proc", "/proc", "proc", 0, NULL);

    execvpe(container_args[0], container_args, container_envp);
    printf("Something's wrong!\n");
    return 1;
}

int main()
{
    const int gid=getgid(), uid=getuid();

    printf("Parent: eUID = %ld;  eGID = %ld, UID=%ld, GID=%ld\n",
            (long) geteuid(), (long) getegid(), (long) getuid(), (long) getgid());

    printf("Parent [%5d] - start a container!\n", getpid());

    unshare(CLONE_NEWUTS | CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWUSER);

    pid_t container_pid = fork();

    if (!container_pid) {
        /* since Linux 3.19 unprivileged writing of /proc/self/gid_map
        * has s been disabled unless /proc/self/setgroups is written
        * first to permanently disable the ability to call setgroups
        * in that user namespace. */
        set_groups("/proc/self/setgroups", "deny");
        //To map the uid/gid,
        // we need edit the /proc/PID/uid_map (or /proc/PID/gid_map) in parent
        //The file format is
        // ID-inside-ns ID-outside-ns length
        //if no mapping,
        // the uid will be taken from /proc/sys/kernel/overflowuid
        // the gid will be taken from /proc/sys/kernel/overflowgid
        set_map("/proc/self/uid_map", 0, uid, 1);
        set_map("/proc/self/gid_map", 0, gid, 1);

        return container_main(NULL);
    }

    printf("Parent [%5d] - Container [%5d]!\n", getpid(), container_pid);

    waitpid(container_pid, NULL, 0);
    printf("Parent [%5d] - container stopped!\n", getpid());
    return 0;
}

