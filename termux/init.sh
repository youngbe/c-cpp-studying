cat > /bin/gcc-me << EOF
#!/bin/bash
gcc \\
    -fwrapv -fwrapv-pointer -fno-trapv \\
    -fdwarf2-cfi-asm -fplt -fno-conserve-stack -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -ffinite-loops -foptimize-sibling-calls -ffast-math -ffp-contract=fast -fallow-store-data-races \\
    -fstack-reuse=all -freg-struct-return -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-all-loops -floop-nest-optimize \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes "\$@"
EOF

cat > /bin/g++-me << EOF
#!/bin/bash
g++ \\
    -fwrapv -fwrapv-pointer -fno-trapv \\
    -fdwarf2-cfi-asm -fplt -fno-conserve-stack -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -ffinite-loops -foptimize-sibling-calls -ffast-math -ffp-contract=fast -fallow-store-data-races \\
    -fstack-reuse=all -freg-struct-return -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-all-loops -floop-nest-optimize \\
    -fno-rtti \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions -fvtable-verify=none -fno-threadsafe-statics \\
    -std=gnu++23 -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes "\$@"
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
