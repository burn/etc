#-- config begin -----------------------------------
DO_repos   = ../lab ../pylab ../etc ../tests4mop 
#--- config end ----------------------------------
SHELL     := bash 
MAKEFLAGS += --warn-undefined-variables
DO_cyan    = \033[36m
DO_yellow  = \033[93m
DO_white   = \033[0m

define DO
$(foreach d,$(DO_repos), printf "$(DO_cyan):: $1 $d$(DO_white) "; cd $d; $(MAKE) $1;)
endef

#.SILENT: 

help :  ## show help
	awk 'BEGIN                { FS = ":.*?## "; print "\nmake [WHAT]" } \
       /^[^[:space:]].*##/  { printf "   \033[36m%-10s\033[0m : %s\n", $$1, $$2} \
      ' $(MAKEFILE_LIST)

put: ## save this repos
	@read -p "commit msg> " x ;\
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

docs/%.html : %.py $(shell which pycco > /dev/null)
	mkdir -p docs
	pycco -d docs $^
	echo "p {text-align: right; }" >> docs/pycco.css

docs/%.html : %.lua $(shell which pycco > /dev/null)
	mkdir -p docs
	cp $^ docs/; \
	cd docs;  cat $^ | lua ../../etc/luaarrow.lua > tmp; mv tmp $^; \
	pycco -d . $^
	rm docs/$^
	echo "p {text-align: right; }" >> docs/pycco.css
<<<<<<< HEAD

# should be dir in root/docs
mds : $(shell ls *.md)

ONE=cat ../README.md | gawk 'BEGIN {FS="\n";RS=""} {print $$0 "\n"; exit}' 
TWOPLUS=cat $@ | gawk 'BEGIN {FS="\n";RS=""} NR>1 { print $$0 "\n"}'

%.md : ;  @echo "$@ ..... "; ($(ONE);  $(TWOPLUS)) > .tmp; mv .tmp $@


=======
>>>>>>> 531fda65638e1a4fd6ede77fbce8194874702d42
