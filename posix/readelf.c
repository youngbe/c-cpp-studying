#include <elf.h>
#include <stdio.h>


static inline int process_elf32(FILE *const fp)
{
    ELF32_Ehdr ehdr;
    int ret;
    ret = fread(&ehdr, sizeof(ehdr), 1, fp);
    if (ret != 0)
        return ret;

    ret = fseek(fp, ehdr.e_shoff, SEEK_SET);
    if (ret != 0)
        return ret;

    Elf32_Shdr *const sh_table = (Elf32_Shdr *)malloc(sizeof(ehdr.e_shentsize * ehdr.e_shnum));
    if (sh_table == NULL)
        return -1;

    if (fread(sh_table, ehdr.e_shentsize * ehdr.e_shnum, 1, fp) != 1) {
        ret = -1;
        goto label_error1;
    }

    free(sh_table);
    return 0;

label_error1:
    free(sh_table);
    return ret;
}

int main(int argc, char *argv[])
{
    if (argc != 2)
        return -1;
    FILE *const fp = fopen(argv[1], "rb");
    if (fp == NULL)
        return -1;
    int ret;
    {
        char temp[4];
        if (fread(temp, 4, 1, fp) != 1) {
            ret = -1;
            goto label_error1;
        }
        if (strncmp(temp, "~ELF", 4) != 0) {
            fputs("error: read elf magic header failed!\n", stderr);
            ret = -1;
            goto label_error1;
        }
    }
    {
        uint8_t class_t;
        if (fread(&class_t, 1, 1, fp) != 1) {
            ret = -1;
            goto label_error1;
        }
        if (class_t == 1) {
            rewind(fp);
            ret = process_elf32(fp);
            if (ret != 0)
                goto label_error1;
        }
        else if (class_t == 2) {
            rewind(fp);
            ret = process_elf64(fp);
            if (ret != 0)
                goto label_error1;
        }
        else {
            fputs("error: unknow elf class type!\n", stderr);
            ret = -1;
            goto label_error1;
        }
    }

    return fclose(fp);

label_error1:
    fclose(fp);
    return ret;
}
