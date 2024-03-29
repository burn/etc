#-- config begin -----------------------------------
DO_repos   = ../ape ../tricks ../tests4mop 
#--- config end ----------------------------------
SHELL     := bash 
MAKEFLAGS += --warn-undefined-variables
DO_cyan    = \033[36m
DO_yellow  = \033[93m
DO_white   = \033[0m

define DO
$(foreach d,$(DO_repos), printf "$(DO_cyan):: $1 $d$(DO_white)\n"; cd $d; $(MAKE) $1;)
endef

.SILENT: 

help :  ## show help
	awk 'BEGIN                { FS = ":.*?## "; print "\nmake [WHAT]" } \
       /^[^[:space:]].*##/  { printf "   \033[36m%-10s\033[0m : %s\n", $$1, $$2} \
      ' $(MAKEFILE_LIST)

put: ## save this repos
	@read -p "$$(PWD) commit msg> " x ;\
	y=$${x:-saved} ; \
	git commit -am "$$y" ; \
	git push --quiet; git status ; \
	echo "$$y: saved!"

pull: ## get updates from cloud
	git pull --quiet

pulls: ## pull from cloud for this (and related) repos
	$(call DO,pull)

puts: ## push to cloud for this (and related) repos
	$(call DO,put)
