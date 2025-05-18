# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# User specific configurations (add --> .bashrc.d)

## Aliases
alias ll='ls -l'
alias la='ls -la'
# smooth transition from sudo to doas
alias sudo='doas'
# to replace sudo entirely perform this command
# ln -s $(which doas) /usr/bin/sudo


## Custom Prompt


## Custom Functions
