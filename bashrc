# Settings for all shells

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

#Environment variables
export EDITOR=gvim
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
alias readelf='greadelf'
alias msc='app msc_robot_arm'
alias d2se='wine ~/.wine/drive_c/users/alexanderthorne/Desktop/Windows/Diablo\ II\ wMods/D2SE.exe'
alias coursera='cd ~/githubcode/coursera_projects'
alias ntab='open . -a iterm'
alias biomeme='cd ~/githubcode/biomeme'
alias gv='gvim &'
alias dev='git checkout development;git fetch'
v() {
    if [ -z "$1" ]; then
        gvim &
    else
        gvim "$1" &
    fi
}
alias fg='echo "Windows - alt tab to your gvim"'

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

# git bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

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
gitshort g git
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

## only binds the given termcap entr(y|ies) to a widget if the terminal supports it
termcap_bind() {
  local widget=$1 key termcap
  shift
  for termcap ; do
    key="$(tput $termcap)"
    [ -n "$key" ] && bind "\"$key\": $widget"
  done
}

# Search history
termcap_bind history-search-backward cuu1 kcuu1
termcap_bind history-search-forward cud1 kcud1

# Simulate Zsh's preexec hook (see: http://superuser.com/a/175802/73015 )
# (This performs the histappend at a better time)
simulate_preexec() {
  [ -n "$COMP_LINE" ] || # skip if doing completion
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] || # skip if generating prompt
    history -a
}
trap simulate_preexec DEBUG

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

clean-git() {
    git branch --merged | egrep -v "(^\*|master|development)" | xargs git branch -d
}

#pdf open shortcuts
alias l0ref='start "" "/c/Users/alex/biomeme/datasheets/st/L0/STM32L073-reference.pdf"'
alias l0data='start "" "/c/Users/alex/biomeme/datasheets/st/L0/STM32L073-datasheet.pdf"'
alias f0ref='start "" "/c/Users/alex/biomeme/datasheets/st/F0/STM32F030-reference-manual.pdf"'
alias f0data='start "" "/c/Users/alex/biomeme/datasheets/st/F0/STM32F030-datasheet.pdf"'
alias f4ref='start "" "/c/Users/alex/biomeme/datasheets/st/STM32F446 reference manual.pdf"'
alias f4data='start "" "/c/Users/alex/biomeme/datasheets/st/STM32F446 datasheet.pdf"'

#random number generation!
random() {
    local R=$RANDOM$RANDOM
    printf '0x%08X (%u)\r\n' $R $R
}


# big ol IAR build and flash functions
# add IAR and ST-Link stuff to path
export PATH=$PATH:/c/Program\ Files\ \(x86\)/STMicroelectronics/STM32\ ST-LINK\ Utility/ST-LINK\ Utility
export PATH=$PATH:/c/Program\ Files\ \(x86\)/IAR\ Systems/Embedded\ Workbench\ 8.2_2/common/bin

function iard() {
    ARGC=$#
    IarBuild.exe $1 -clean Debug
    if [ $ARGC -eq 1 ]; then
        IarBuild.exe $1 -build Debug -log all -parallel 4 2>&1 | tee build.log
    else
        echo "" | cat > build.log
        IarBuild.exe $1 -build Debug -log all -parallel 4 2>&1 | cat >> build.log
    fi;
    echo "***** WARNINGS *****"
    grep 'Warning\[' build.log | cat > warnings.log
    grep 'Remark\[' build.log | cat >> warnings.log
    cat warnings.log | sed ''/Warning/s//`printf "\033[36mWarning\033[0m"`/'' > warnings.log
    cat warnings.log | sed ''/Remark/s//`printf "\033[31mRemark\033[0m"`/'' > warnings.log
    echo "$(cat warnings.log)"
    echo "***** ERRORS *****"
    grep 'Error\[' build.log | cat > errors.log
    cat errors.log | sed ''/Error/s//`printf "\033[34mError\033[0m"`/'' > errors.log
    echo "$(cat errors.log)"

    echo "***** SIZE *****"
    grep 'of readonly' build.log
    grep 'of readwrite' build.log

    rm build.log
    rm warnings.log
    rm errors.log
}

function iarm() {
    ARGC=$#
    if [ $ARGC -eq 1 ]; then
        IarBuild.exe $1 -make Debug -log all -parallel 4 2>&1 | tee build.log
    else
        echo "" | cat > build.log
        IarBuild.exe $1 -make Debug -log all -parallel 4 2>&1 | cat >> build.log
    fi;
    echo "***** WARNINGS *****"
    grep 'Warning\[' build.log | cat > warnings.log
    grep 'Remark\[' build.log | cat >> warnings.log
    cat warnings.log | sed ''/Warning/s//`printf "\033[36mWarning\033[0m"`/'' > warnings.log
    cat warnings.log | sed ''/Remark/s//`printf "\033[31mRemark\033[0m"`/'' > warnings.log
    echo "$(cat warnings.log)"
    echo "***** ERRORS *****"
    grep 'Error\[' build.log | cat > errors.log
    cat errors.log | sed ''/Error/s//`printf "\033[34mError\033[0m"`/'' > errors.log
    echo "$(cat errors.log)"

    echo "***** SIZE *****"
    grep 'of readonly' build.log
    grep 'of readwrite' build.log

    rm build.log
    rm warnings.log
    rm errors.log
}

function iarmf(){
    echo "IAR EWARM Build Project and Flash (ST-Link CLI Utility)"
    path=$1
    printf "Project: %s\n" $1/*ewp
    iarm $1/*.ewp q
    printf "Executable: %s\n" $path/Debug/Exe/*.hex
    ST-LINK_CLI.exe -c SWD -p $path/Debug/Exe/*.hex -V -Rst -HardRst
}

# add stuff to path for Doxygen call graphs
export PATH=$PATH:/c/Program\ Files\ \(x86\)/Graphviz2.38/bin

# add stuff to path for cppcheck
export PATH=$PATH:~/apps/cppcheck

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# segno (python) QR creation
create-qr-codes() {
	echo Creating QR Code \'$1-valid.png\'
	segno "$1; 20290301; SW-TEST" --output $1-valid.png --scale=10
	echo Creating QR Code \'$1-invalid.png\'
	segno "$1; 20180301; SW-TEST" --output $1-invalid.png --scale=10 --light=yellow
}

# call to bash_secrets to setup whatever environmental secrets you needed
source ~/.bash_secrets
export_secrets
