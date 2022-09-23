#!/bin/bash
#apt --no-install-recommends install open-vm-tools-desktop
#apt --no-install-recommends install openjdk-18-jdk-headless python3-minimal python3-pip mysql-server
apt --no-install-recommends install vim gcc g++ git openssh-client make gdb git tree gedit


#dnf --setopt=install_weak_deps=False install open-vm-tools-desktop
#dnf --setopt=install_weak_deps=False install java-latest-openjdk-headless python3 python3-pip mysql-server
dnf --setopt=install_weak_deps=0 install ncurses util-linux vim tree gedit gcc gcc-c++ openssh make gdb git

cat > /bin/gcc-me << EOF
#!/bin/bash
gcc -fstack-reuse=all -freg-struct-return -fdwarf2-cfi-asm -fplt -fipa-pta -fdevirtualize-at-ltrans \\
    -fwrapv -fwrapv-pointer -fno-trapv -ffast-math -ffp-contract=fast \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions \\
    -std=c2x -g0 -Ofast -Wall -Wextra -pedantic "\$@"
EOF

cat > /bin/g++-me << EOF
#!/bin/bash
g++ -fstack-reuse=all -freg-struct-return -fdwarf2-cfi-asm -fplt -fipa-pta -fdevirtualize-at-ltrans \\
    -fwrapv -fwrapv-pointer -fno-trapv -ffast-math -ffp-contract=fast -fno-threadsafe-statics -fno-rtti \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions -fvtable-verify=none \\
    -std=c++23 -g0 -Ofast -Wall -Wextra -pedantic "\$@"
EOF

chmod +x /bin/gcc-me /bin/g++-me

cat >> /usr/share/vim/vim82/defaults.vim <<EOF

set mouse-=a
set expandtab
set tabstop=4
set shiftwidth=4
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
