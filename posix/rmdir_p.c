#include <stdio.h>

#include <dirent.h>
#include <linux/limits.h>
#include <sys/stat.h>
#include <unistd.h>

#include <string.h>


static inline int _rmdir_p(char *const path, const size_t path_len, const size_t path_len_max)
{
    DIR *const dir = opendir(path);
    if (dir == NULL)
        return -1;

    int ret;
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        const size_t ld = strlen(entry->d_name);
        if (path_len + ld > path_len_max)
            goto label_error1;
        strcat(&path[path_len], entry->d_name);
        struct stat _stat;
        ret = lstat(path, &_stat);
        if (ret != 0)
            goto label_error2;
        if (S_ISDIR(_stat.st_mode)) {
            size_t lnew = path_len + ld;
            if (path[lnew - 1] != '/') {
                if (lnew == path_len_max)
                    goto label_error2;
                path[lnew++] = '/';
                path[lnew] = '\0';
            }
            ret = _rmdir_p(path, lnew, path_len_max);
        }
        else
            ret = unlink(path);
        if (ret != 0)
            goto label_error2;
        path[path_len] = '\0';
    }

    ret = closedir(dir);
    if (ret != 0)
        return ret;

    return rmdir(path);

label_error2:
    path[path_len] = '\0';
label_error1:
    closedir(dir);
    return ret;
}

int rmdir_p(const char *const path)
{
    struct stat _stat;
    int ret;

    ret = lstat(path, &_stat);
    if (ret != 0)
        return ret;

    if (!S_ISDIR(_stat.st_mode))
        return -1;

    size_t lp = strlen(path);
    if (lp > PATH_MAX)
        return -1;
    char _path[PATH_MAX];
    if (lp == 0) {
        _path[0] = '.';
        _path[1] = '/';
        _path[2] = '\0';
        lp = 2;
    }
    else {
        strcpy(_path, path);
        if (_path[lp - 1] != '/') {
            if (lp == PATH_MAX)
                return -1;
            _path[lp++] = '/';
            _path[lp] = '\0';
        }
    }
    return _rmdir_p(_path, lp, PATH_MAX);
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fputs("argc != 2\n", stderr);
        return -1;
    }
    printf("%d\n", rmdir_p(argv[1]));
    return 0;
}

/*
// 清空一个文件中的所有内容
// 清除后将会自动关闭dir_fd
static inline int _clear_dir_fd(const int dir_fd)
{
    DIR *const dir = opendirfd(dir_fd);
    struct dirent *entry;

    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        struct stat _stat;
        ret = fstatat(dir_fd, entry->d_name, &_stat, AT_SYMLINK_NOFOLLOW);
        if (ret == -1) {
            return -1;
        }
        if (S_ISDIR(_stat.mode)) {
            const int new_dir_fd = openat(dir_fd, entry->d_name, );
            _clear_dir_fd(new_dir_fd);
            rmdirat(dir_fd, entry->d_name)
        }
        else {
            unlinkat(dir_fd, entry->d_name);
        }

    }

    return closedir(dir_fd);
}

// 清空一个文件中的所有内容
static inline int _clear_dir(DIR *const dir)
{
    int ret;
    struct dirent *entry;

    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;

        struct stat _stat;
        ret = fstatat(dir_fd, entry->d_name, &_stat, AT_SYMLINK_NOFOLLOW);
        if (ret == -1) {
            return -1;
        }
        if (S_ISDIR(_stat.mode)) {
            const int new_dir_fd = openat(dir_fd, entry->name);

        }
        else {
        }

    }

    return 0;




    int ret;
    DIR *dir;
    int dir_fd;
    struct dirent *entry;

    dir = opendir(path);
    if (dir == NULL) {
        ret = -1;
        goto label_error0;
    }
    dir_fd = dirfd(dir);
    if (dir_fd == -1) {
        ret = dir_fd;
        goto label_error1;
    }

    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
            continue;
        struct stat _stat;
        ret = fstatat(fd, entry->d_name, &_stat, AT_SYMLINK_NOFOLLOW);
        if (ret == -1) {
            goto label_error1;
        }

        if (_stat)
    }

    closedir(dir);
    return 0;

label_error1:
    closedir(dir);
label_error0:
    return ret;
}

int rmdir_p(const char *const path)
{
    int ret;
    struct stat _stat;

    ret = lstat(path, &_stat);
    if (ret != 0) {
        goto label_error0;
    }

    if (!S_ISDIR(_stat.mode)) {
        ret = -1;
        goto label_error0;
    }

    ret =  _rmdir_p(path);
    if (ret != 0) {
        goto label_error0;
    }

    return rmdir(path);

label_error0:
    return ret;
}
*/
