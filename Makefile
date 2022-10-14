MAKEFLAGS += --silent
SHELL=/bin/bash
R=$(shell dirname $(shell git rev-parse --show-toplevel))

help: ## show help
	echo ""; echo "make [OPTIONS]"; echo ""; echo "OPTIONS:"
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk ' \
	  BEGIN {FS = ":"} \
	        {gsub(/^.*## /,"",$$3); printf "  \033[36m%-10s\033[0m %s\n", $$2, $$3}'

tools: $R/dotrc $R/readme $R/data local

$R/readme:; cd $R; git clone https://github.com/burn/readme
$R/data  :; cd $R; git clone https://github.com/burn/data
$R/dotrc :; cd $R; git clone https://github.com/burn/dotrc; 

installall: install tools

install: vims  ## install all 
	mkdir -p    $(HOME)/.config/ranger
	ln -sf $R/dotrc/vimrc     $(HOME)/.vimrc
	ln -sf $R/dotrc/rc.conf   $(HOME)/.config/ranger/rc.conf
	ln -sf $R/dotrc/nanorc    $(HOME)/.nanorc
	ln -sf $R/dotrc/tmux-conf $(HOME)/.tmux-conf
	ln -sf $R/dotrc/bashrc    $(HOME)/.bashrc

vims: ~/.vim/bundle/Vundle.vim ## sub-routine. just install vim
	ln -sf $R/dotrc/vimrc $(HOME)/.vimrc

~/.vim/bundle/Vundle.vim: 
	- [[ ! -d "$@" ]] && git clone https://github.com/VundleVim/Vundle.vim.git $@

y?=saving  
itso: ## commit to Git. To add a message, set `y=message`.
	git commit -am "$y"; git push; git status

define red
  echo -e "\ncd \033[31;1;4m$1\033[0m; $2"
endef

pulln:;   cd $R; for i in *; do (cd $$i; $(call red,$$i,pull);   git pull)                      done
statusn:; cd $R; for i in *; do (cd $$i; $(call red,$$i,status); git status --porcelain)        done
pushn:;   cd $R; for i in *; do (cd $$i; $(call red,$$i,push);   git commit -am "$y"; git push) done

pulls:;    cd ../dotrc; $(MAKE) pulln   ## update all
pushs:;    cd ../dotrc; $(MAKE) pushn   ## commit all
statuses:; cd ../dotrc; $(MAKE) statusn ## status on all

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
		--pretty-print="$R/dotrc/lua.ssh" \
		--columns 3                  \
		-M letter                     \
		--footer=""                    \
		--right-footer=""               \
	  -o	 $@.ps $<
	ps2pdf $@.ps $@; rm $@.ps
	open $@
