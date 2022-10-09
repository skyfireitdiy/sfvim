#!/bin/bash

bak_config() {
	old_config=$1
	bak_config=${1}_bak
	if [ -f $bak_config ] || [ -d $bak_config ]; then
		echo "删除旧的备份文件" $bak_config
		rm -f $bak_config
	fi
	if [ -f $old_config ] || [ -d $old_config ] ; then
		mv $old_config ${old_config}_bak
		echo "备份$old_config 到 ${old_config}_bak"
	fi
}

replace_config() {
	old_config=$1
	new_config=$2
	bak_config $1
	ln -sf $new_config $old_config
}


config_vim(){
	replace_config ~/.vimrc $(pwd)/_vimrc

	if [ -d ~/.vim ]; then
		mv ~/.vim ~/.vim_bak
	fi

	# 使用 ghproxy 做代理
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://ghproxy.com/https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	sed -i 's/https:\/\/github\.com/https:\/\/ghproxy\.com\/https:\/\/github\.com/g' ~/.vim/autoload/plug.vim

	ln -sf $(pwd)/_vimrc ~/.vimrc

	echo vim配置成功！
	echo 首次启动 vim 的时候会有一些报错，因为相关插件未安装，需要执行命令 :PlugInstall
}


config_fish(){
	mkdir -p ~/.config/fish
	replace_config ~/.config/fish/config.fish $(pwd)/config.fish
	replace_config ~/.config/fish/fish_variables $(pwd)/fish_variables
	echo fish 配置成功
}


config_tmux(){
	bak_config ~/.tmux
	git clone https://ghproxy.com/https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	replace_config ~/.tmux.conf $(pwd)/_tmux.conf
	echo tmux配置成功！
}

config_emacs(){
	replace_config ~/.emacs.d $(pwd)/_emacs.d
	replace_config ~/.spacemacs $(pwd)/_spacemacs
	echo emacs配置成功！
}

config_i3() {
	replace_config ~/.config/i3 $(pwd)/i3
	replace_config ~/.config/i3status $(pwd)/i3status
	echo i3 配置成功!
}

config_konsole() {
	replace_config ~/.local/share/konsole/skyfire.profile $(pwd)/skyfire.profile
	echo konsole 配置成功！
}

while test $# -gt 0
do
	config_$1
	shift
done

