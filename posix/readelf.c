#include <elf.h>

#include <stdio.h>
#include <string.h>

enum elf_type
{
    ELF32,
    ELF64,
};

struct ELF_Header
{
    enum elf_type type;
    union
    {
        Elf32_Ehdr ehdr32;
        Elf64_Ehdr ehdr64;
    };
};

int parse_elf(struct ELF_Header *const header, FILE *const fp)
{
    rewind(fp);
    uint8_t head5[5];
    if (fread(&head5, 5, 1, fp) != 1)
        return -1;
    const uint8_t magic_model[4] = {0x7f, 'E', 'L', 'F'};
    if (memcmp(head5, magic_model, 4) != 0)
        return -1;

    if (head5[4] == 1) {
        rewind(fp);
        if (fread(&header->ehdr32, sizeof(header->ehdr32), 1, fp) != 1)
            return -1;
        header->type = ELF32;
    }
    else if (head5[4] == 2) {
        rewind(fp);
        if (fread(&header->ehdr64, sizeof(header->ehdr64), 1, fp) != 1)
            return -1;
        header->type = ELF64;
    }
    else
        return -1;

    return 0;
}

/*
static inline int process_elf32(FILE *const fp)
{
    Elf32_Ehdr ehdr;
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
*/

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fputs("Error: argc != 2 !\n", stderr);
        return -1;
    }
    FILE *const fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        fprintf(stderr, "Error: fopen(%s) failed!\n", argv[1]);
        return -1;
    }
    struct ELF_Header elf_header;
    int ret = parse_elf(&elf_header, fp);
    if (ret) {
        fprintf(stderr, "Failed to parse elf!\n");
        goto label_error1;
    }


    ret = fclose(fp);
    if (ret)
        fprintf(stderr, "Error: fclose(%s)\n", argv[1]);
    return ret;

label_error1:
    fclose(fp);
    return ret;
}
