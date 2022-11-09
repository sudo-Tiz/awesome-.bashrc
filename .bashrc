# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

##############################################################################################
######################################## USER PREFERENCES ####################################
##############################################################################################
IWantToReplaceLsWithExa=1
IWantToPrintTheNumberOfFilesWhenLs=1
IWantToReplaceCatWithBat=1
IWantToReplaceLessWithVimLess=1

IWantToInstallMyFavouriteApp=1
ListOfFavoriteApp="vim terminator mlocate tree"
######################################## USEFUL SHIT  ########################################
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# show potential good files when trying to cd in a non existant dir
shopt -s cdspell

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
set skip-completed-text on

# Autoriser le cd'ing sans taper la partie cd si la version bash> = 4
[ ${BASH_VERSINFO[0]} -ge 4 ] && shopt -s autocd


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

iatest=$(expr index "$-" i)
# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi
######################################## PROMPT ##############################################
# IF new prompt file exist
if [ -e $HOME/.bash_prompt ]; then
  source $HOME/.bash_prompt
else
  git_branch() { git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }
  HOST='\033[02;36m\]\h'
  USER='\033[0;32m\]\u'
  SEP='\033[0;37m\]@'
  TIME='\033[01;34m\]\t \033[01;32m\]'
  LOCATION=' \033[01;31m\]`pwd | sed "s#\(/[^/]\{1,\}/[^/]\{1,\}/[^/]\{1,\}/\).*\(/[^/]\{1,\}/[^/]\{1,\}\)/\{0,1\}#\1_\2#g"`'
  BRANCH=' \033[00;33m\]$(git_branch)\[\033[00m\]\n\$ '
  PS1=$TIME$USER$SEP$HOST$LOCATION$BRANCH
fi
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac


# change prompt
alias ps1mple='export PS1="\$" PROMPT_COMMAND=""'
alias ps1ong="load_prompt"


######################################## COLOR ###############################################
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='/bin/ls --color=auto'
  /usr/bin/ls --color=al >/dev/null 2>&1 && alias ls='/usr/bin/ls -F --color=al' || alias ls='/usr/bin/ls -G'
  alias grep='/usr/bin/grep --color=auto'
  alias fgrep='/usr/bin/fgrep --color=auto'
  alias egrep='/usr/bin/egrep --color=auto'
fi

###################################### COMPLETION ############################################
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
######################################## IMPORT #############################################

if [ -e $HOME/.bash_alias ]; then
  source $HOME/.bash_alias
fi
if [ -e $HOME/.bash_functions ]; then
  source $HOME/.bash_functions
fi
if [ -e $HOME/.bash_personnal ]; then
  source $HOME/.bash_personnal
fi

######################################## SUDO ##############################################
if [ $(id -u) -eq 0 ]; then #remove sudo
  alias sudo=''
fi

######################################## PRESET ############################################
if [ $IWantToPrintTheNumberOfFilesWhenLs -eq 1 ]; then
  nbf() {
    nbvisiblefiles=$(/usr/bin/ls $1 | /bin/wc -l)
    nbhiddenfiles=$(find $1 -mindepth 1 -maxdepth 1 -name '.*' | /bin/wc -l)
    nbtotalfiles=$(/usr/bin/ls -lA $1 | grep -v 'total ' | /bin/wc -l)
    echo -e "     \033[1;34m[$nbvisiblefiles files\033[1;37m|$nbhiddenfiles hidden|\033[1;31m$nbtotalfiles total]"
  }
fi
if [ $IWantToReplaceCatWithBat -eq 1 ]; then
  if [ $(dpkg-query -W -f='${Status}' bat 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo replacing cat with bat && sudo /bin/apt -qq update && sudo /bin/apt -qq upgrade -y && sudo /bin/apt -qq install bat -y
  fi
  alias cat="batcat --paging=never -pp --style='plain' --theme=TwoDark "
fi
if [ $IWantToReplaceLessWithVimLess -eq 1 ]; then
  if [ $(dpkg-query -W -f='${Status}' vim 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo download vim and replacing less with vimless && sudo /bin/apt -qq update && sudo /bin/apt -qq upgrade -y && sudo /bin/apt -qq install vim -y
  fi
  alias less="/usr/share/vim/vim*/macros/less.sh"
fi
if [ $IWantToInstallMyFavouriteApp -eq 1 ]; then
for a in $ListOfFavoriteApp; do
  if [ $(dpkg-query -W -f='${Status}' $a 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  sudo /bin/apt -qq update && sudo /bin/apt -qq upgrade -y 
    echo download $a 
    sudo /bin/apt -qq install $a -y
  fi
done
fi

if [ $IWantToReplaceLsWithExa -eq 1 ]; then
  export EXA_COLORS="di=1;32"
  export EXA_COLORS="ex=31"
  #if not exist,  download exa
  if [ ! -e /bin/exa ] && [ ! -e /usr/bin/exa ] && [ ! -e /usr/local/bin/exa ]; then
    echo replacing ls by exa
    
    while true; do
      read -p "Do you wish to install EXA ? " yn
      case $yn in
          [Yy]* ) make install; break;;
          [Nn]* ) exit;;
          * ) echo "Please answer yes or no.";;
      esac
    done


    if [ $(echo "$(lsb_release -rs 2>/dev/null) >= 20.10" | bc -l 2>/dev/null) -eq 1 ] 2>/dev/null; then
      sudo apt install exa
    else
      mkdir ~/install_exa &&
        dpkg-query -W -f='${Status}' wget 2>/dev/null | grep -c "ok installed" || (sudo /bin/apt -qq update && sudo /bin/apt -qq upgrade -y && sudo /bin/apt -qq install wget -y) && wget -qq "https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip" -P ~/install_exa &&
        dpkg-query -W -f='${Status}' unzip 2>/dev/null | grep -c "ok installed" || (sudo /bin/apt -qq install unzip -y) && unzip -qq ~/install_exa/exa-linux-x86_64-v0.10.0.zip -d ~/install_exa &&
        # binary
        sudo /bin/cp ~/install_exa/bin/exa /usr/local/bin/exa && echo exa binary installed
      # man page (don't install if not present)
      test -e usr/local/man/man1/ && sudo /bin/cp ~/install_exa/man/* /usr/local/man/man1/ && echo exa man page installed
      # completions
      test -e /etc/bash_completion.d/ || sudo mkdir -p /etc/bash_completion.d/ && sudo /bin/cp ~/install_exa/completions/exa.bash /etc/bash_completion.d/ && echo exa completion installed

      rm -rf ~/install_exa

    fi
  fi
  #TODO
  #nfb the desired folder and no the actual (replace alias by function ?)
  alias l="nbf && exa --sort extension"
  alias ll="nbf && exa --sort extension  -l"
  alias la='nbf && exa --sort extension  -aF'   # show hidden files
  alias lla='nbf && exa --sort extension  -laF' # show hidden files
  alias lt='nbf && exa -T'
  alias ltl='nbf && exa -Tl'
  alias lll='/usr/bin/clear && nbf && exa --sort extension  -l'
else
  # Keep using ls
  alias la='nbf && ls -Alh'               # show hidden files
  alias l='nbf && ls -aFh'                # file type extensions
  alias lx='nbf && ls -lXBh'              # sort by extension
  alias lk='nbf && ls -lSrh'              # sort by size
  alias lc='nbf && ls -lcrh'              # sort by change time
  alias lu='nbf && ls -lurh'              # sort by access time
  alias lr='nbf && ls -lRh'               # recursive ls
  alias lt='nbf && ls -ltrh'              # sort by date
  alias lm='nbf && ls -alh |more'         # pipe through 'more'
  alias lw='nbf && ls -xAh'               # wide listing format
  alias ll='nbf && ls -Fls'               # long listing format
  alias labc='nbf && ls -lap'             #alphabetical sort
  alias lf="nbf && ls -l | egrep -v '^d'" # files only
  alias ldir="nbf && ls -l | egrep '^d'"  # directories only
fi




##############################################################################################
######################################## ALIASES #############################################
##############################################################################################
alias helpme="grep --color=always ALIASES ~/.bashrc -A100000 | less"

#show folder size
alias dush="du -sh"
lss() {
  if [ -d "$1" ]; then
    du -h --max-depth=1 . 2>/dev/null | sort -rh
  else
    du -h --max-depth=1 $1 2>/dev/null | sort -rh
  fi
}

########################################   APT   ########################################
alias sagi='sudo /bin/apt-get install'
alias ragi='sudo /bin/apt-get remove'
alias sagu='sudo /bin/apt-get update && sudo /bin/apt-get upgrade'
alias saclean='sudo /bin/apt-get autoclean && sudo /bin/apt-get autoremove && sudo /bin/apt-get clean'
########################################   CD    ########################################
alias bd='cd "$OLDPWD"' # equivalent to : cd -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cdde='cd ~/Bureau && /usr/bin/clear && /usr/bin/ls'
alias cddp='cd ~/Documents/programmation && /usr/bin/clear && /usr/bin/ls'
alias cdd='cd ~/Documents && /usr/bin/clear && /usr/bin/ls'
alias mdtemp='cd `mktemp -d`'
# mkdir + cd
md() { [ $# = 1 ] && mkdir -p "$@" && cd "$@" || echo "Error - no directory passed!"; }
#cd + ls
cl() { DIR="$*"; if [ $# -lt 1 ]; then DIR=$HOME; fi; builtin cd "${DIR}" && l;}
######################################## DOCKER ########################################
alias doc='sudo /bin/docker'
alias doco='sudo /bin/docker-compose'
alias rmdoc='sudo /bin/docker rm -f $(/bin/docker ps -a -q)'
# Containers
alias mitmproxy='sudo /bin/docker run --rm -it -v /tmp/mitmproxy:/home/mitmproxy/.mitmproxy -p 192.168.1.33:8080:8080 -p 127.0.0.1:8081:8081 mitmproxy/mitmproxy:6.0.2 mitmweb --showhost --web-host 0.0.0.0 --anticache'
alias cordova='sudo /bin/docker run -it beevelop/cordova bash'
alias zphisher='sudo /bin/docker run --rm --net host -p 8080:8080 -it htrtech/zphisher'
alias startlamp='sudo /bin/docker run -v ~/programmation/docker/lamp/www:/var/www/html -v ~/programmation/docker/lamp/mysql:/var/lib/mysql -p 80:80 -p 3306:3306 --rm lioshi/lamp:php5'
alias startvnc='sudo /bin/docker run --name linVNC -p 6080:80 -p 5900:5900 dorowu/ubuntu-desktop-lxde-vnc:bionic'
alias startbeef='sudo /bin/docker run --rm -p 3000:3000 janes/beef'
######################################## GIT ########################################
alias glone='git clone'
alias gull='git pull'
alias gush='git push'
alias gommit='git commit -m'
alias gadd='git add'
alias gradd='git restore --staged'
alias gremouve='git remove'
alias gatus='git status'
########################################  FAST  ########################################
alias vi='vim'
alias ee='exit'
alias code.='code . && exit'
alias coba='code ~/.bashrc'
alias viba='vi ~/.bashrc'
alias coprompt='code ~/.bash_prompt'
alias viprompt='vi ~/.bash_prompt'
alias tree='tree -CAhF --dirsfirst'
alias cp='cp -r'
alias rmrf='rm  --recursive --force --verbose '
alias rm='rm -rf'
alias copypaste='xclip -selection clipboard'
alias rmhistory='echo "" >> ~/.bash'
alias h="history | grep "
alias f="find . | grep "

######################################## CHMOD ########################################
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 744='chmod -R 744'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
###################################### PYTHON ENV ######################################
alias ve='virtualenv ./.env'
alias va='source ./.env/bin/activate || source ./env/bin/activate'
alias veva='virtualenv ./.env && source ./.env/bin/activate'
alias da='deactivate'
######################################## INFOS ########################################
# Show to command to install my bashrc and copy it to the clipboard
alias showmybashrc='echo "curl https://raw.githubusercontent.com/sudo-Tiz/awesome-.bashrc/master/install.sh | bash"; echo "curl https://raw.githubusercontent.com/sudo-Tiz/awesome-.bashrc/master/install.sh | bash"|xclip'
alias showdisk='free -h && echo "disk" && echo &&  df -h && du -h --max-depth=1 . | sort -rh'

alias shownetwork='echo "---LSOF---"; sudo lsof -nP -i; echo "---SS---"; sudo ss -atupn; echo "---NETSTAT---"; sudo netstat -atupen'
showlan() { nmap -sL 192.168.1.0/24 | grep '(' |tail -n +2 | tail -n +2 | head -n -1 | awk {'print $5 " -> " $6'} | column -t; }



###################################### SCREEN ROTATION ######################################
if [ $(dpkg-query -W -f='${Status}' libxrandr2 2>/dev/null | grep -c "ok installed") -eq 1 ] && [ $(dpkg-query -W -f='${Status}' x11-xserver-utils 2>/dev/null | grep -c "ok installed") -eq 1 ]  ; then
  alias xrandrright="xrandr --output $(xrandr | grep "connected primary" | awk '{print $1}') --rotate right"
  alias xrandrnormal="xrandr --output $(xrandr | grep "connected primary" | awk '{print $1}') --rotate normal"
  alias xrandrleft="xrandr --output $(xrandr | grep "connected primary" | awk '{print $1}') --rotate left"
  alias xrandrinverted="xrandr --output $(xrandr | grep "connected primary" | awk '{print $1}') --rotate inverted"
  alias xrandr120="xrandr --output $(xrandr | grep "connected primary" | awk '{print $1}') --mode 1920x1080 --rate 120"
  alias xrandr48="xrandr --output $(xrandr | grep "connected primary" | awk '{print $1}') --mode 1920x1080 --rate 48"
fi
######################################## OTHERS ########################################
# Copy progress bar
alias cpv='rsync -ah --info=progress2'
alias mvv='rsync -ah --remove-source-files --info=progress2'
# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | /bin/wc -l\` \$t; done 2> /dev/null"
# Add an "alert" alias for long running commands.  Use like so:  sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Micro to speaker
alias micON='pactl load-module module-loopback latency_msec=1'
alias micOFF='pactl unload-module module-loopback'
# Wsl
alias windaube='/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe'



# Open in explorer
alias exp.='exp . ; exit'
exp() {
  if [ -d "$1" ]; then
    nautilus . >/dev/null 2>&1 &
  else
    nautilus $1 >/dev/null 2>&1 &
  fi
}

#Computes a math calculation
c() { printf "%s\n" "$*" | bc; }

pdftojpg(){
  [ $# = 1 ] && convert -density 150 "$1" -quality 90 "`echo $1| sed s/.pdf/%03d.jpg/g`" || echo ERROR
}


#Extract everything
extract() {
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz) tar xvzf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.tar.xz) tar xvJf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1" ;;
    *.tbz2) tar xvjf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.xz) unxz "$1" ;;
    *.exe) cabextract "$1" ;;
    *) echo "'$1': unrecognized file compression" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Encryption
aes256cbc() { [ $# = 2 ] && openssl aes-256-cbc -salt -pbkdf2 -in $1 -out $2 || echo "ERROR";  }
aes256cbc_d() { [ $# = 2 ] && openssl aes-256-cbc -salt -pbkdf2 -d -in $1 -out $2 || echo "ERROR";  }

# Searches for text in all files in the current folder
ftext() {
  # -i case-insensitive
  # -I ignore binary files
  # -H causes filename to be printed
  # -r recursive search
  # -n causes line number to be printed
  # optional: -F treat search term as a literal, not a regular expression
  # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
  grep -iIHrn --color=always "$1" . | less -r
}

#text to speach using espeak + mbrola
#saythis() {  [ $# = 1 ] && echo $1 | espeak -v mb/mb-fr4  --pho | mbrola /usr/share/mbrola/fr4 - -.au | aplay || echo "ERROR";}
#text to speach using picotts
if [ $(dpkg-query -W -f='${Status}' libttspico-utils 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
saythis() {  [ $# = 1 ] && MY_TEMP=`mktemp` && MY_TEMP_WAV=$MY_TEMP".wav" && mv $MY_TEMP $MY_TEMP_WAV &&  pico2wave -l fr-FR -w $MY_TEMP_WAV "$1" &&  aplay $MY_TEMP_WAV && rm $MY_TEMP_WAV || echo "ERROR";}
fi


victory() {
  echo "
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmm=================================================mmmmmmmmmm
mmmmmmmm/                                                  \mmmmmmmm
mmmmmmmm\     $1 is the fucking winner !                  /mmmmmmmmm
mmmmmmmmm=================================================mmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmddddmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmdyydmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdyyyyyyyyyyyyymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhhyyo++++++++++hhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmyysss/----------yyhmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmyyo::-----------yyhmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmyyo-------------yyhmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmoo+---O----X----ooymmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmm------------------+mmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhs-------------hhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmhss/-------+ssmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdddo//--://yddmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdhhdmm--+mmdhhmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhhhhddhyyyhddhhhhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhhhhdyoydsohdhhhhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhhhhdysydhohdhhhhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhhhhdyssyyohdhhhhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmhhhhhdddddddddhhhhdmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmooshhhhhyyhhhhhhooymmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmm::+hhyyyyyyyyyhh::ommmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmddhyyyyyddhyyyyydddmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdyyyyymmdyyyyymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdyyyyymmdyyyyymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdyyyyymmdyyyyymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmdyyyyymmdyyyyymmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmm++/:::::mmh:::::++smmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmm::::::::mmh:::::::ommmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"

}
