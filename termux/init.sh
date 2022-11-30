# -floop-nest-optimize ：此选项已经存在多年，但仍未启用
# -fsection-anchors ： x86 不支持
# -mskip-rax-setup ：只支持x86 32位 -mgeneral-regs-only
# -funroll-completely-grow-size ：目前没有发现作用
# -fstrict-volatile-bitfields ：很有意思
# -frecord-gcc-switches
# -finhibit-size-directive
# -ftree-vectorize ：本身没作用，显式打开相当于打开 -ftree-loop-vectorize -ftree-slp-vectorize，显示关闭相当于关闭 那俩；更多地使用浮点寄存器，是-O2到-O3负优化的罪魁祸首

cat > /bin/gcc-me << EOF
#!/bin/bash
gcc \\
    -fwrapv -fwrapv-pointer -fno-trapv \\
    -fdwarf2-cfi-asm -fplt -fstack-reuse=all -fno-float-store -fjump-tables -fbit-tests -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -ffinite-loops -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize -ffast-math -ffp-contract=fast -fexcess-precision=fast -fno-signed-zeros -fno-trapping-math -fallow-store-data-races \\
    -fno-pcc-struct-return -freg-struct-return -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-all-loops \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes "\$@"
EOF

cat > /bin/g++-me << EOF
#!/bin/bash
g++ \\
    -fwrapv -fwrapv-pointer -fno-trapv \\
    -fdwarf2-cfi-asm -fplt -fstack-reuse=all -fno-float-store -fjump-tables -fbit-tests -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -ffinite-loops -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize -ffast-math -ffp-contract=fast -fexcess-precision=fast -fno-signed-zeros -fno-trapping-math -fallow-store-data-races \\
    -fno-pcc-struct-return -freg-struct-return -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-all-loops \\
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
