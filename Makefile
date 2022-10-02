MAKEFLAGS += --silent
SHELL=/bin/bash
R=$(shell git rev-parse --show-toplevel)

help: ## show help
	echo ""; echo "# dotrc"; echo "make [OPTIONS]"; echo ""; echo "OPTIONS:"
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}\
	               {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: vims  ## install all 
	mkdir -p    $(HOME)/.config/ranger
	ln -sf $R/vimrc     $(HOME)/.vimrc
	ln -sf $R/rc.conf   $(HOME)/.config/ranger/rc.conf
	ln -sf $R/nanorc    $(HOME)/.nanorc
	ln -sf $R/tmux-conf $(HOME)/.tmux-conf
	ln -sf $R/bashrc    $(HOME)/.bashrc

vims: ~/.vim/bundle/Vundle.vim ## sub-routine. just install vim
	ln -sf $R/vimrc     $(HOME)/.vimrc

~/.vim/bundle/Vundle.vim: 
	git clone https://github.com/VundleVim/Vundle.vim.git $@

y?=saving
itso: ## commit to Git. To add a message, set `y=message`.
	git commit -am "$y"; git push; git status

status:
	cd $R/../; for i in *; do (cd $$i; echo $$i; git status --porcelain) done

pull:
	cd $R/../; for i in *; do (cd $$i; echo $$i; git pull) done

push:
	cd $R/../; for i in *; do (cd $$i; echo $$i; git commit -am "save all"; git push) done


