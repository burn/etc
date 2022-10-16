MAKEFLAGS += --silent
SHELL=/bin/bash
R=$(shell dirname $(shell git rev-parse --show-toplevel))

help: ## show help
	egrep -E '^[\.a-zA-Z0-9]+\s?:.*## .*$$' $(MAKEFILE_LIST) | sort | awk ' \
		BEGIN {FS=":"; print "\nmake[OPTIONS]\n\nOPTIONS:\n"} \
	        {gsub(/^.*## /,"",$$3); printf "  \033[36m%-10s\033[0m %s\n",$$2,$$3}'

install: dotfiles tools 

tools: $R/etc $R/readme $R/data 

$R/readme:; cd $R; git clone https://github.com/burn/readme
$R/data  :; cd $R; git clone https://github.com/burn/data


dotfiles: vims  ## install all 
	mkdir -p    $(HOME)/.config/ranger
	ln -sf $R/etc/vimrc     $(HOME)/.vimrc
	ln -sf $R/etc/rc.conf   $(HOME)/.config/ranger/rc.conf
	ln -sf $R/etc/nanorc    $(HOME)/.nanorc
	ln -sf $R/etc/tmux-conf $(HOME)/.tmux-conf
	ln -sf $R/etc/bashrc    $(HOME)/.bashrc

vims: ~/.vim/bundle/Vundle.vim ## sub-routine. just install vim
	ln -sf $R/etc/vimrc $(HOME)/.vimrc

~/.vim/bundle/Vundle.vim: 
	- [[ ! -d "$@" ]] && git clone https://github.com/VundleVim/Vundle.vim.git $@

y?=saving  
itso: ## commit to Git. To add a message, set `y=message`.
	git commit -am "$y"; git push; git status

define red
  echo -e "\ncd \033[31;1;4m$1\033[0m; $2"
endef

add:;    cd $R; for i in *; do (cd $$i; $(call red,$$i,pull);   $(MAKE) itso; )                            done
pull:;   cd $R; for i in *; do (cd $$i; $(call red,$$i,pull);   git pull)                      done
status:; cd $R; for i in *; do (cd $$i; $(call red,$$i,status); git status --porcelain)        done
push:;   cd $R; for i in *; do (cd $$i; $(call red,$$i,push);   git commit -am "$y"; git push) done


~/tmp/%.pdf: %.lua  ## .lua ==> .pdf
	mkdir -p ~/tmp
	echo "pdf-ing $@ ... "
	a2ps                 \
		-Br                 \
		-l 100                 \
		--file-align=fill      \
		--line-numbers=1        \
		--borders=no             \
		--pro=color               \
		--left-title=""            \
		--pretty-print="$R/etc/lua.ssh" \
		--columns 3                  \
		-M letter                     \
		--footer=""                    \
		--right-footer=""               \
	  -o	 $@.ps $<
	ps2pdf $@.ps $@; rm $@.ps
	open $@
