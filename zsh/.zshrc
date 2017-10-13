export ZSH=/home/deadsec/.oh-my-zsh
ZSH_THEME="peepcode"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
source $ZSH/oh-my-zsh.sh
source $ZSH/zsh_aliases
source $ZSH
source $ZSH/zsh_functions

## AUTOSUGGESTION
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

HISTFILE=~/.histfile
HISTSILZE=1000
SAVEHIST=1000

## EXPORTS
export EDITOR='vim'
export TERMINAL='urxvt'
export LANG=en_US.UTF-8
export ANDROID_HOME=/opt/android-sdk
export XDG_CONFIG_HOME=/home/deadsec/.config
export XDG_DATA_HOME=/home/deadsec/.config
export datadir=/home/deadsec/.config

## BUILD CM
export LANG=C
export PATH=~/bin:$PATH
export PATH=$PATH:~/android/android-sdk/tools/
export PATH=$PATH:~/android/android-sdk/platform-tools/
export PATH=$PATH:~/bin2/
export USE_CCACHE=1
export PATH=$PATH:$HOME/.config/bspwmpanel/panel
export CCACHE_DIR=~/.ccache

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0232323" #black
    echo -en "\e]P82B2B2B" #darkgrey
    echo -en "\e]P1D75F5F" #darkred
    echo -en "\e]P9E33636" #red
    echo -en "\e]P287AF5F" #darkgreen
    echo -en "\e]PA98E34D" #green
    echo -en "\e]P3D7AF87" #brown
    echo -en "\e]PBFFD75F" #yellow
    echo -en "\e]P48787AF" #darkblue
    echo -en "\e]PC7373C9" #blue
    echo -en "\e]P5BD53A5" #darkmagenta
    echo -en "\e]PDD633B2" #magenta
    echo -en "\e]P65FAFAF" #darkcyan
    echo -en "\e]PE44C9C9" #cyan
    echo -en "\e]P7E5E5E5" #lightgrey
    echo -en "\e]PFFFFFFF" #white
    startx
    clear #for background artifacting
fi

## For wallpaper based scheme
(wal -r &)
source "$HOME/.cache/wal/colors.sh"
