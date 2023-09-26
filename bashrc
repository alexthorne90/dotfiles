# Settings for all shells

#Environment variables
export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
export CVS_RSH=ssh
export LESS="-RM"
#export NODE_PATH=/usr/local/lib/node_modules

# bash tab completion non-case-sensitive and show all options after a tab
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

# Settings for interactive shells
# return if not interactive
[[ $- != *i* ]] && return

# set a default terminal type for deficient systems or weird terminals
tput longname >/dev/null 2>&1 || export TERM=xterm

warn() {
  tput setaf 1 >&2
  printf '%s\n' "$*"
  tput sgr0 >&2
}

# History settings
# ignoreboth=ignoredups:ignorespace
# ignoredups = ignore duplicate commands in history
# ignorespace = ignore commands that start with space
HISTCONTROL=ignoreboth

# Save (effectively) all commands ever
HISTSIZE=10000000
HISTFILESIZE=10000000

# only append the history at the end (shouldn't actually be needed - histappend)
shopt -s histappend

alias ll="ls -lahG --color"
alias l=ll
alias f='find . -name'

# Athorne custom
alias desk='cd ~/Desktop'
alias dls='cd ~/Downloads'
alias info='open ~/Desktop/Me/info.rtf'
alias biomeme='cd ~/githubcode/biomeme'
alias gv='gvim &'
alias dev='git checkout development;git fetch'
alias read='bat README.md'
v() {
    if [ -z "$1" ]; then
        nvim
    else
        nvim "$1"
    fi
}

# dotnet autocompletion
alias dn='dotnet'
_dotnet_bash_complete()
{
  local word=${COMP_WORDS[COMP_CWORD]}

  local completions
  completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)"
  if [ $? -ne 0 ]; then
    completions=""
  fi

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}
complete -f -F _dotnet_bash_complete dn

# function to alias git commands with the git completion built in
gitshort() {
	short=$1; shift
	long=$1; shift
	alias $short="git $long $@"
	__git_complete $short _git_$long
}

# Git
alias gs='git status'
gitshort gb branch -va
alias gcm='git commit -m'
gitshort gf fetch
gitshort gp pull
alias changes='git diff --numstat --shortstat start'
alias gsu='git submodule update'
gitshort gst stash
alias gca='git commit --amend'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glv='git lg'
git-set-user() {
    git config --global user.name "Alex Thorne"
    git config --global user.email $1
    echo "Set git user info to:"
    echo "$(git config user.name)"
    echo "$(git config user.email)"
}
alias git-personal='git-set-user alexthorne90@gmail.com'
alias git-biomeme='git-set-user alex@biomeme.com'

# bhaskell git (with my 'gitshort' additions)
alias g='git'
alias gap='git add -p'
alias gci='git commit'
gitshort gco checkout
gitshort gd diff
gitshort gdc diff --cached
alias gka='gitk --all'
alias gls='git ls-files'
alias gpop='git stash pop'
alias gstash='git stash'
gitshort gl log

# installed 'ripgrep' and it's super dope, aliasing it because I'm used to gg
alias gg='rg'

# Vim
alias vi='gvim &'

# Ceedling
alias rta='rake clean test:all'
alias rc='rake clean; rake clobber'
alias rtd='rake test:delta'
alias rr='rake release'
alias cc='ceedling clean;ceedling'

# give me gcc colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Simulate Zsh's preexec hook (see: http://superuser.com/a/175802/73015 )
# (This performs the histappend at a better time)
simulate_preexec() {
  [ -n "$COMP_LINE" ] || # skip if doing completion
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] || # skip if generating prompt
    history -a
}
trap simulate_preexec DEBUG

run_command_until_failure() {
    if [ $# -ne 2 ]
    then
        echo "Usage: $0 <command> <max_attempts>"
        return
    fi
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    for ((i=1; i <= $2; i++)) do
        output=$($1)
        result=$?
        if [ $result -ne 0 ]
        then
            echo -e "${RED}FAILURE on attempt $i"
            echo $output
            return
        else
            echo -n -e "${GREEN}."
        fi
    done
}

#biomeme stuff
alias ports='python -m serial.tools.list_ports'
serial() {
    local logfile=~/Documents/serial-logs/$1-$(date '+%F-%H:%M').log
    echo "Logging $1@115200 to $logfile"
    # winpty -Xallow-non-tty python -m serial.tools.miniterm $1 115200 -e --raw | tee "$logfile"
    python -u -m serial.tools.miniterm $1 115200 -e --raw | tee "$logfile"
}
serial_no_echo() {
    local logfile=~/Documents/serial-logs/$1-$(date '+%F-%H:%M').log
    echo "Logging $1@115200 to $logfile"
    winpty -Xallow-non-tty python -m serial.tools.miniterm $1 115200 --raw | tee $logfile
}
pull-phone-logs() {
  local infoLog=$1$(date '+%F-%H_%M')-info.log
  echo "Pull INFO log to $infoLog \n"
  adb pull sdcard/Android/data/com.biomeme.three9go/files/INFO_LOG.txt $infoLog

  local errorLog=$1$(date '+%F-%H_%M')-error.log
  echo "Pull INFO log to $errorLog \n"
  adb pull sdcard/Android/data/com.biomeme.three9go/files/ERROR_LOG.txt $errorLog
}
alias tags='ctags -R --exclude=build --exclude=driver/build --exclude=common/build'
alias d='cd ~/githubcode/detector'
alias h='cd ~/githubcode/heater'
alias b='cd ~/githubcode/baseboard'
alias pi='pipenv install --dev; pipenv shell'
alias po='poetry install; poetry shell'

clean-git() {
    git branch --merged | egrep -v "(^\*|master|development)" | xargs git branch -d
}

#random number generation!
random() {
    local R=$RANDOM$RANDOM
    printf '0x%08X (%u)\r\n' $R $R
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# segno (python) QR creation
create-qr-codes() {
	echo Creating QR Code \'$1-valid.png\'
	segno "$1; 20290301; SW-TEST" --output $1-valid.png --scale=10
	echo Creating QR Code \'$1-invalid.png\'
	segno "$1; 20180301; SW-TEST" --output $1-invalid.png --scale=10 --light=yellow
}

# MAC VS WINDOWS SPLIT
if [[ $OSTYPE == msys ]]; then    # Windows
    alias fg='echo "Windows - alt tab to your gvim"'
    # add stuff to path for Doxygen call graphs - WINDOWS ONLY
    export PATH=$PATH:/c/Program\ Files\ \(x86\)/Graphviz2.38/bin
else
    # git bash completion - MAC ONLY
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
fi

#command prompt customization
prompt() {
    local last_status=$?

    local WHITE="\[\033[1;37m\]"
    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local GRAY="\[\033[0;37m\]"
    local BLUE="\[\033[0;34m\]"
    local LIGHT_BLUE="\[\033[1;34m\]"
    local YELLOW="\[\033[1;33m\]"
    local RED="\[\033[1;31m\]"
    local no_color='\[\033[0m\]'

    local time="${YELLOW}\d \@$no_color"
    local whoami="${GREEN}\u$no_color"
    #local whoami="${GREEN}\u@\h$no_color"   This one has the computer name (alex@macbook)
    local dir="${CYAN}\w$no_color"

    local joblist
    jobs=$(jobs)
    for item in $jobs
    do
        str=$item
        joblist=$joblist${str:0:3}" "
    done
    # each line of "jobs" output has 3 parts ("
    # first 3 characters of each part of the job list (ex: "[1] Sto vim")
    joblist=$BLUE$joblist

    local branch
    if git rev-parse --git-dir >/dev/null 2>/dev/null ; then
        branch=$(git branch | awk '/^\*/ { print $2 }')
        branch="${branch:+$LIGHT_BLUE$branch }"
    else
        unset branch
    fi

    local last_fail
    if test $last_status -ne 0 ; then
        last_fail="=> ${YELLOW}Err: $last_status${no_color}\n"
    else
        unset last_fail
    fi

    PS1="\n$time $whoami $branch$dir $joblist\n$last_fail$no_color\$ "
}
PROMPT_COMMAND=prompt
# retain $PROMPT_DIRTRIM directory components when the prompt is too long
PROMPT_DIRTRIM=3

# call to bash_secrets to setup whatever environmental secrets you needed
source ~/.bash_secrets
export_secrets

# source general git bash completion, downloaded with this command:
# curl -o ~/bash_completion.d/git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
source ~/bash_completion.d/git

## HRBV Result Commands
alias mockHrbvViral="three9-mock com7 --isp --force_cqs '28, 30, 30, 22, 33, 26, 32, 34, 25, 27, 30, 30, 25, 28, 24, 25, 28, 24, 28, 25, 26, 24, 28, 24, 0, 0, 0'"
alias mockHrbvBacterial="three9-mock com7 --isp --force_cqs '26, 31, 26, 23, 27, 26, 30, 30, 25, 25, 30, 28, 29, 28, 29, 24, 25, 24, 26, 24, 22, 30, 30, 26, 0, 0, 0'"
alias mockHrbvNegative="three9-mock com7 --isp --force_cqs '26, 28, 23, 24, 29, 26, 30, 30, 25, 27, 29, 31, 36, 27, 30, 25, 29, 24, 29, 25, 24, 30, 29, 28, 0, 0, 0'"
alias mockHrbvBothPositive="three9-mock com7 --isp --force_cqs '28, 31, 26, 23, 28, 26, 27, 30, 24, 27, 31, 28, 28, 32, 27, 25, 28, 28, 27, 26, 25, 26, 30, 24, 0, 0, 0'"
alias mockHrbvInconclusive1="three9-mock com7 --isp --force_cqs '28, 31, 26, 23, 28, 26, 27, 30, 24, 27, 31, 28, 28, 32, 27, 25, 28, 38, 27, 26, 25, 26, 30, 24, 0, 0, 0'"
alias mockHrbvInconclusive2="three9-mock com7 --isp --force_cqs '28, 31, 26, 23, 28, 26, 27, 30, 24, 27, 31, 28, 28, 32, 27, 25, 28, 0, 27, 26, 25, 26, 30, 24, 0, 0, 0'"
alias mockHrbvInconclusive3="three9-mock com7 --isp --force_cqs '0, 0, 0, 23, 28, 26, 27, 30, 24, 27, 31, 28, 28, 32, 27, 25, 28, 28, 27, 26, 25, 26, 30, 24, 0, 0, 0'"
alias mockHrbvInvalidUserAction1="three9-mock com7 --isp --fail 01001412345678 --fail_cycle 20"
alias mockHrbvInvalidUserAction2="three9-mock com7 --isp --fail 0C001412345678 --fail_cycle 20"
alias mockHrbvInvalidUserAction5="three9-mock com7 --isp --fail C3001412345678 --fail_cycle 20"

## NVM
# default to newest node (20.6.1)
export PATH=$HOME/.nvm/versions/node/v20.6.1/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
