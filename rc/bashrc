 
here="$(dirname $(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd ))"

alias gp="git add *;git commit -am save;git push;git status"
alias grep='grep --color=auto'
alias ls="ls -G"
alias sbcl="sbcl --noinform --script "
alias repl="rlwrap sbcl --noinform " 

export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH="$PWD:/opt/homebrew/bin:/usr/local/Cellar:/usr/local/opt:/usr/local/bin:/opt/homebrew/cellar:$PATH"
export LUA_PATH="?;?.lua;../?/?;../?/?.lua"

here() { cd $1; basename `pwd`; }

lisp()  {
    f=$1
    shift
    $(which sbcl) --noinform --script $f  $* 2> >( gawk '/^Backtrace / {exit} 1' ) 
}

PROMPT_COMMAND='echo -ne "💫 $(git branch 2>/dev/null | grep '^*' | colrm 1 2):";PS1="$(here ..)/$(here .):\!\e[m ▶ "'
