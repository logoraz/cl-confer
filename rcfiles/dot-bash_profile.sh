# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

## General Env
export LC_COLLATE=C
export EDITOR=emacs #change to Lem when it is ready, need emacs for git rebase...
export BROWSER=nyxt

## XDG Env
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

## Update PATH - Common Lisp Utilities/Applications

### Qlot Source
qlot=$XDG_DATA_HOME/qlot/bin

#### Lem Source (local install)
lem=$XDG_DATA_HOME/common-lisp/custom/lem

### Nyxt Source (local install)
nyxt=$XDG_DATA_HOME/common-lisp/custom/nyxt

# Update PATH
export PATH="$qlot:$lem:$nyxt:$PATH"
