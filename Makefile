MAKEFLAGS += --silent
SHELL=/bin/bash

help:
	echo ""; echo "make [OPTIONS]"; echo ""; echo "OPTIONS:"
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}\
	               {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: ## install all the dot files
	mkdir -p    $(HOME)/.config/ranger
	ln -sf $d/rc.conf     $(HOME)/.config/ranger/rc.conf
	ln -sf $d/vimrc     $(HOME)/.vimrc
	ln -sf $d/nanorc    $(HOME)/.nanorc
	ln -sf $d/tmux-conf $(HOME)/.tmux-conf
	ln -sf $d/bashrc    $(HOME)/.bashrc

vims: ~/.vim/bundle/Vundle.vim ## install vim

~/.vim/bundle/Vundle.vim: 
	git clone https://github.com/VundleVim/Vundle.vim.git $@

all: install vims ## install everything

y?=saving
itso: ## commit to Git. To add a message, set `y=message`.
	git commit -am "$y"; git push; git status
