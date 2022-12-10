apt update
apt --no-install-recommends -y install apt-utils
apt --no-install-recommends -y install whiptail
apt --no-install-recommends --auto-remove --purge -y full-upgrade
apt --no-install-recommends -y install language-pack-zh-hans

#apt --no-install-recommends install open-vm-tools-desktop
#apt --no-install-recommends install openjdk-18-jdk-headless python3-minimal python3-pip mysql-server
apt --no-install-recommends install vim gedit gcc g++ git openssh-client make gdb git

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
