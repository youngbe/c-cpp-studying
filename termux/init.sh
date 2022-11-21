# -floop-nest-optimize ：此选项已经存在多年，但仍未启用
# -fsection-anchors ： x86 不支持
# -mskip-rax-setup ：只支持x86 32位 -mgeneral-regs-only
# -funroll-completely-grow-size ：目前没有发现作用

cat > /bin/gcc-me << EOF
#!/bin/bash
gcc \\
    -fwrapv -fwrapv-pointer -fno-trapv \\
    -fdwarf2-cfi-asm -fplt -fstack-reuse=all -fjump-tables -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -ffinite-loops -foptimize-sibling-calls -ffast-math -ffp-contract=fast -fallow-store-data-races \\
    -freg-struct-return -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-all-loops \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes "\$@"
EOF

cat > /bin/g++-me << EOF
#!/bin/bash
g++ \\
    -fwrapv -fwrapv-pointer -fno-trapv \\
    -fdwarf2-cfi-asm -fplt -fstack-reuse=all -fjump-tables -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -ffinite-loops -foptimize-sibling-calls -ffast-math -ffp-contract=fast -fallow-store-data-races \\
    -freg-struct-return -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-all-loops \\
    -fno-rtti \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions -fvtable-verify=none -fno-threadsafe-statics \\
    -std=gnu++23 -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra "\$@"
EOF

chmod +x /bin/gcc-me /bin/g++-me

cat >> /usr/share/vim/vim90/defaults.vim <<EOF

set mouse-=a
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set cindent
set cinoptions+=g0
EOF

cat >> ~/.inputrc << EOF
"\e[5~": history-search-backward
"\e[6~": history-search-forward
"\e[H": beginning-of-line
"\e[F": end-of-line
EOF

cat >> ~/.bashrc << EOF
HISTSIZE=-1
HISTFILESIZE=-1
EOF

export LANG=zh_CN.utf8 LANGUAGE=zh_CN.utf8
echo "export LANG=zh_CN.utf8 LANGUAGE=zh_CN.utf8" >> "$HOME/.profile"
