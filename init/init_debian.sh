apt update
apt --no-install-recommends -y install apt-utils
apt --no-install-recommends -y install whiptail
apt --no-install-recommends --auto-remove --purge -y full-upgrade
apt --no-install-recommends -y install language-pack-zh-hans

# 常用操作
apt --no-install-recommends -y install git git-lfs openssh-client curl ca-certificates vim tar gzip xz-utils bzip2 lzma cpio apt-file dpkg-dev
apt-file update
# c/c++
echo 'deb http://apt.llvm.org/lunar/ llvm-toolchain-lunar-17 main' >> /etc/apt/sources.list
echo 'deb-src http://apt.llvm.org/lunar/ llvm-toolchain-lunar-17 main' >> /etc/apt/sources.list
curl -L https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
apt update
apt --no-install-recommends -y install gcc g++ libc6-dev clang-17 lld-17 libclang-rt-17-dev libunwind-17-dev libc++-17-dev libc++abi-17-dev gdb
# c/c++:i386
apt --no-install-recommends -y install libc6-dev-i386 lib32gcc-12-dev
# or 
apt --no-install-recommends -y install libc6-dev-amd64-cross libc6-dev-i386-amd64-cross lib32gcc-12-dev
# or
apt --no-install-recommends -y install libc6-dev:i386 lib32gcc-12-dev
# or
apt --no-install-recommends -y install gcc-i686-linux-gnu libc6-dev-i386-cross
# c/c++: arm64
dpkg --add-architecture arm64
apt update
apt --no-install-recommends -y install gcc-aarch64-linux-gnu libc6-dev-arm64-cross g++-aarch64-linux-gnu libclang-rt-17-dev:arm64
# c/c++: arm32
apt --no-install-recommends -y install gcc-arm-linux-gnueabi libc6-dev-armel-cross
# c/c++: armhf
apt --no-install-recommends -y install gcc-arm-linux-gnueabihf libc6-dev-armhf-cross
# 内核编译
apt --no-install-recommends -y install clang-17 lld-17 llvm-17 make bc flex bison python3-minimal libelf-dev libssl-dev libncurses-dev dwarves





# -fdwarf2-cfi-asm -fplt :只是配置
# -floop-nest-optimize ：此选项已经存在多年，但仍未启用
# -fsection-anchors ： x86 不支持
# -mskip-rax-setup ：只支持x86_64 -mgeneral-regs-only
# -funroll-completely-grow-size ：目前没有发现作用
# -fstrict-volatile-bitfields ：很有意思
# -frecord-gcc-switches
# -finhibit-size-directive
# -ftree-vectorize ：本身没作用，显式打开相当于打开 -ftree-loop-vectorize -ftree-slp-vectorize，显示关闭相当于关闭 那俩；更多地使用浮点寄存器，是-O2到-O3负优化的罪魁祸首
# -fno-pcc-struct-return -freg-struct-return :二进制不兼容
# -ffinite-loops : clang中可能删除无线循环

cat > /bin/gcc-me << EOF
#!/bin/bash
gcc \\
    -fstack-reuse=all -fjump-tables -fbit-tests -fno-non-call-exceptions -fno-float-store -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip -ffp-contract=fast \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize -ffast-math -fno-rounding-math -fexcess-precision=fast -fno-signed-zeros -fno-trapping-math -fallow-store-data-races \\
    -fdelete-dead-exceptions -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-loops -funroll-all-loops \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes -Wshadow "\$@"
EOF

cat > /bin/g++-me << EOF
#!/bin/bash
g++ \\
    -fstack-reuse=all -fjump-tables -fbit-tests -fno-non-call-exceptions -fno-float-store -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip -ffp-contract=fast \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize -ffast-math -fno-rounding-math -fexcess-precision=fast -fno-signed-zeros -fno-trapping-math -fallow-store-data-races \\
    -fdelete-dead-exceptions -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-loops -funroll-all-loops \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions -fvtable-verify=none -fno-threadsafe-statics \\
    -std=gnu++23 -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wshadow "\$@"
EOF

chmod +x /bin/gcc-me /bin/g++-me

# clang 不支持的选项：
# -fstack-reuse=all -fbit-tests -fno-float-store -fstdarg-opt -fno-conserve-stack
# -fexcess-precision=fast -fallow-store-data-races
# -fdelete-dead-exceptions -fipa-pta -fdevirtualize-at-ltrans -funroll-all-loops
# -fno-instrument-functions
# 和GCC不同的选项：
# -ffinite-loops
# -fno-rounding-math -ffp-contract=fast
# -fslp-vectorize == -ftree-slp-vectorize
# -fvectorize == -ftree-loop-vectorize

cat > /usr/bin/clang-me << EOF
#!/bin/bash
clang-17 \\
    -Xclang -pic-level -Xclang 0 -fno-addrsig -fuse-ld=lld-17 --rtlib=compiler-rt -unwindlib=libunwind \\
    -fno-float-store -fexcess-precision=fast -funroll-all-loops -Wno-ignored-optimization-argument -Wno-unused-command-line-argument \\
    -fjump-tables -fno-non-call-exceptions -ftrivial-auto-var-init=uninitialized -fzero-call-used-regs=skip -fno-rounding-math \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -fvectorize -fslp-vectorize -ffast-math -ffp-contract=fast -fno-signed-zeros -fno-trapping-math -funroll-loops \\
    -fmerge-all-constants \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes -Wshadow "\$@"
EOF

cat > /usr/bin/clang++-me << EOF
#!/bin/bash
clang++-17 \\
    -Xclang -pic-level -Xclang 0 -fno-addrsig -fuse-ld=lld-17 --rtlib=compiler-rt -unwindlib=libunwind -stdlib=libc++ \\
    -fno-float-store -fexcess-precision=fast -funroll-all-loops -Wno-ignored-optimization-argument -Wno-unused-command-line-argument \\
    -fjump-tables -fno-non-call-exceptions -ftrivial-auto-var-init=uninitialized -fzero-call-used-regs=skip -fno-rounding-math \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -fvectorize -fslp-vectorize -ffast-math -ffp-contract=fast -fno-signed-zeros -fno-trapping-math -funroll-loops \\
    -fmerge-all-constants \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all \\
    -std=gnu++2b -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes -Wshadow "\$@"
EOF

chmod +x /bin/clang-me /bin/clang++-me

cat > /bin/aarch64-gcc-me << EOF
#!/bin/bash
aarch64-linux-gnu-gcc \\
    -fstack-reuse=all -fjump-tables -fbit-tests -fno-non-call-exceptions -fno-float-store -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip -ffp-contract=fast \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize -ffast-math -fno-rounding-math -fexcess-precision=fast -fno-signed-zeros -fno-trapping-math -fallow-store-data-races \\
    -fdelete-dead-exceptions -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-loops -funroll-all-loops \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes -Wshadow "\$@"
EOF

cat > /bin/aarch64-g++-me << EOF
#!/bin/bash
aarch64-linux-gnu-g++ \\
    -fstack-reuse=all -fjump-tables -fbit-tests -fno-non-call-exceptions -fno-float-store -ftrivial-auto-var-init=uninitialized -fstdarg-opt -fno-conserve-stack -fzero-call-used-regs=skip -ffp-contract=fast \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize -ffast-math -fno-rounding-math -fexcess-precision=fast -fno-signed-zeros -fno-trapping-math -fallow-store-data-races \\
    -fdelete-dead-exceptions -fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-loops -funroll-all-loops \\
    -fstack-check=no -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all -fno-instrument-functions -fvtable-verify=none -fno-threadsafe-statics \\
    -std=gnu++23 -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wshadow "\$@"
EOF

chmod +x /bin/aarch64-gcc-me /bin/aarch64-g++-me

cat > /usr/bin/aarch64-clang-me << EOF
#!/bin/bash
clang-17 \\
    --target=aarch64-linux-gnu \\
    -Xclang -pic-level -Xclang 0 -fno-addrsig -fuse-ld=lld-17 --rtlib=compiler-rt \\
    -fno-float-store -fexcess-precision=fast -funroll-all-loops -Wno-ignored-optimization-argument -Wno-unused-command-line-argument \\
    -fjump-tables -fno-non-call-exceptions -ftrivial-auto-var-init=uninitialized -fzero-call-used-regs=skip -fno-rounding-math \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -fvectorize -fslp-vectorize -ffast-math -ffp-contract=fast -fno-signed-zeros -fno-trapping-math -funroll-loops \\
    -fmerge-all-constants \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all \\
    -std=gnu2x -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes -Wshadow "\$@"
EOF

cat > /usr/bin/aarch64-clang++-me << EOF
#!/bin/bash
clang++-17 \\
    --target=aarch64-linux-gnu \\
    -Xclang -pic-level -Xclang 0 -fno-addrsig -fuse-ld=lld-17 --rtlib=compiler-rt \\
    -fno-float-store -fexcess-precision=fast -funroll-all-loops -Wno-ignored-optimization-argument -Wno-unused-command-line-argument \\
    -fjump-tables -fno-non-call-exceptions -ftrivial-auto-var-init=uninitialized -fzero-call-used-regs=skip -fno-rounding-math \\
    -fomit-frame-pointer -fstrict-aliasing -fdelete-null-pointer-checks -foptimize-sibling-calls -fvectorize -fslp-vectorize -ffast-math -ffp-contract=fast -fno-signed-zeros -fno-trapping-math -funroll-loops \\
    -fmerge-all-constants \\
    -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables \\
    -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-split-stack -fcf-protection=none -fno-sanitize=all \\
    -std=gnu++2b -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wstrict-prototypes -Wshadow "\$@"
EOF

chmod +x /bin/aarch64-clang-me /bin/aarch64-clang++-me

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
set hlsearch
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
HISTTIMEFORMAT='%F %T '
EOF




#apt --no-install-recommends install openjdk-18-jdk-headless python3-minimal python3-pip mysql-server
apt --no-install-recommends install vim gcc libc6-dev clang g++ git openssh-client make gdb gedit
# -m32 路线一 (gcc-multilib默认路线)
libc6-dev-i386 lib32gcc-12-dev
# -m32 路线二
libc6-dev-amd64-cross libc6-dev-i386-amd64-cross lib32gcc-12-dev

# 拼音输入fcitx5
sudo apt --no-install-recommends install fcitx5 fcitx5-pinyin fcitx5-module-cloudpinyin fcitx5-frontend-gtk2 fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-frontend-qt5 fcitx5-module-xorg language-selector-gnome
# 拼音输入ibus
sudo apt --no-install-recommends install ibus ibus-gtk ibus-gtk3 ibus-gtk4 ibus-libpinyin



# 配置vim语法检查
apt --no-install-recommends install vim-ale vim-youcompleteme clang-format
git clone https://github.com/vim/vim
cd vim/src
apt --no-install-recommends install liblua5.4-dev libperl-dev tcl-dev ruby-dev python3-minimal libpython3-dev python2-minimal libpython2-dev
ln -s /usr/include/lua5.4 /usr/include/lua
# aarch64
ln -s /usr/lib/x86_64-linux-gnu/liblua5.4.so /usr/lib/x86_64-linux-gnu/liblua.so
# xiu gai wen jian
./configure --prefix=/usr/local/vim --enable-fail-if-missing --enable-luainterp=dynamic --enable-mzschemeinterp --enable-perlinterp=dynamic --enable-pythoninterp=dynamic --enable-python3interp=dynamic --enable-tclinterp=dynamic --enable-rubyinterp=dynamic --enable-cscope --enable-terminal --enable-autoservername --enable-multibyte --enable-xim --enable-fontset --enable-gui=auto --enable-gtk2-check --enable-gnome-check --enable-gtk3-check --enable-motif-check --enable-athena-check --enable-nextaw-check CFLAGS="-g0 -O3 -fno-exceptions -fno-asynchronous-unwind-tables -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-unwind-tables -fcf-protection=none -fno-dwarf2-cfi-asm -fno-split-stack"
make -j8
make install
cd ../..
rm -rf vim

cat >> /usr/local/vim/share/vim/vim82/defaults.vim <<EOF


set mouse-=a
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set cindent
set cinoptions+=g0

set rtp+=/usr/share/vim-ale
set rtp+=/usr/share/vim-youcompleteme

let g:ale_c_cc_executable="gcc-me"
let g:ale_c_cc_options='-fno-exceptions -fno-asynchronous-unwind-tables -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-unwind-tables -fcf-protection=none -fno-split-stack -std=c2x -g0 -O3 -Wall -Wextra -pedantic'
let g:ale_cpp_cc_executable="g++-me"
let g:ale_cpp_cc_options='-fno-asynchronous-unwind-tables -fno-stack-check -fno-stack-clash-protection -fno-stack-protector -fno-unwind-tables -fcf-protection=none -fno-split-stack -std=c++23 -g0 -O3 -Wall -Wextra -pedantic'
let g:ale_set_highlights = 1
let g:ale_set_signs = 0
let g:ale_completion_enabled = 0
"highlight ALEError cterm=underline ctermul=red ctermbg=none
"highlight ALEWarning cterm=underline ctermul=Blue ctermbg=none

let g:ycm_semantic_triggers =  { 'c,cpp': [ 're!\w' ],}
"let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 0
set completeopt+=longest
"set completeopt-=preview

set equalprg=py3f\ /usr/share/vim/addons/syntax/clang-format.py
EOF
update-alternatives --install /bin/vim vim /usr/local/vim/bin/vim 50
#ln -s /usr/local/vim/bin/vim /bin/vim
