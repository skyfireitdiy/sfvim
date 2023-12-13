#!/bin/bash

add_sudoer() {
    user=$(whoami)
    sudo bash -c "cat>>/etc/sudoers<<EOF
    $user ALL=(ALL:ALL) NOPASSWD: ALL
EOF
"
}

add_source() {
	./install.sh pacman
}

install_must_app() {
    sudo pacman -Sy
    sudo pacman -S --noconfirm archlinuxcn-keyring yay fakeroot
}

update() {
    yay -Su
}

install_normal_app() {
    yay -S --noconfirm fish neovim fzf ranger w3m make  lazygit tmux  konsole fcitx-im  fcitx-configtool fcitx-sogoupinyin  ripgrep universal-ctags gcc nodejs xsel npm  go rustup fd linux-headers flameshot  p7zip wget aria2 unzip python-pynvim  wqy-zenhei wqy-microhei-lite wqy-microhei  wqy-bitmapfont nerd-fonts-complete  ueberzug ffmpegthumbnailer poppler epub-thumbnailer-git net-tools reflector python-pip yarn witch python-jedi
}


config_fish(){
    chsh -s /usr/bin/fish
    sudo chsh -s /usr/bin/fish
}


config(){
    ./install.sh fish tmux x vim konsole kitty alacritty hx i3 polybar
    config_fish
}



install_all(){
    add_sudoer
    add_source
    install_must_app
    update
    install_normal_app
    config
}
