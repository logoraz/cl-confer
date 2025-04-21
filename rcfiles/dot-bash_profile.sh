# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

## General Env
export LC_COLLATE=C
export EDITOR=emacs
export BROWSER=zen
# Experimental alternatives
#export EDITOR=lem
#export BROWSER=nyxt

## XDG Env
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

## Update PATH - Common Lisp Utilities/Applications

### Qlot Source
qlot=$XDG_DATA_HOME/qlot/bin

#### Lem Source (local install)
lem=$XDG_DATA_HOME/common-lisp/custom/lem

# Update PATH
export PATH="$qlot:$lem:$PATH"
