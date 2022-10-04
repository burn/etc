#   __              __                     
#  /\ \            /\ \__                  
#  \_\ \     ___   \ \ ,_\   _ __    ___   
#  /'_` \   / __`\  \ \ \/  /\`'__\ /'___\ 
# /\ \L\ \ /\ \L\ \  \ \ \_ \ \ \/ /\ \__/ 
# \ \___,_\\ \____/   \ \__\ \ \_\ \ \____\
#  \/__,_ / \/___/     \/__/  \/_/  \/____/

MAKEFLAGS += --silent
SHELL=/bin/bash
R=$(shell dirname $(shell git rev-parse --show-toplevel))

help: ## show help
	echo ""; echo "# dotrc"; echo "make [OPTIONS]"; echo ""; echo "OPTIONS:"
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}\
	               {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

install: vims  ## install all 
	mkdir -p    $(HOME)/.config/ranger
	ln -sf $R/dotrc/vimrc     $(HOME)/.vimrc
	ln -sf $R/dotrc/rc.conf   $(HOME)/.config/ranger/rc.conf
	ln -sf $R/dotrc/nanorc    $(HOME)/.nanorc
	ln -sf $R/dotrc/tmux-conf $(HOME)/.tmux-conf
	ln -sf $R/dotrc/bashrc    $(HOME)/.bashrc

vims: ~/.vim/bundle/Vundle.vim ## sub-routine. just install vim
	ln -sf $R/dotrc/vimrc   $(HOME)/.vimrc

~/.vim/bundle/Vundle.vim: 
	- [[ ! -d "$@" ]] && git clone https://github.com/VundleVim/Vundle.vim.git $@

y?=saving  
itso: ## commit to Git. To add a message, set `y=message`.
	git commit -am "$y"; git push; git status

define red
  echo -e "\ncd \033[31;1;4m$1\033[0m; $2"
endef

pull:;   cd $R; for i in *; do (cd $$i; $(call red,$$i,pull);   git pull)                      done
status:; cd $R; for i in *; do (cd $$i; $(call red,$$i,status); git status --porcelain)        done
push:;   cd $R; for i in *; do (cd $$i; $(call red,$$i,push);   git commit -am "$y"; git push) done
