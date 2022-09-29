d=$(shell pwd)

install: 
	ln -sf $d/vimrc     $(HOME)/.vimrc
	ln -sf $d/nanorc    $(HOME)/.nanorc
	ln -sf $d/tmux-conf $(HOME)/.tmux-conf
	ln -sf $d/bashrc    $(HOME)/.bashrc-my

vims: ~/.vim/bundle/Vundle.vim

~/.vim/bundle/Vundle.vim:
	git clone https://github.com/VundleVim/Vundle.vim.git $@

all: install vims

y?=saving
itso:
	git commit -am "$y"; git push; git status
