# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias wallpaperengine="hyprctl dispatch -- exec __GL_THREADED_OPTIMIZATIONS=0 linux-wallpaperengine --silent --fps 30 --screen-root HDMI-A-1 --screen-root DP-2"

# https://github.com/Notenlish/anifetch
alias anifetch="python3 '$HOME/.local/share/anifetch/anifetch.py' --fast-fetch -W 112 -H 63 -f '$HOME/.local/share/anifetch/katana-zero.gif' -c '--symbols narrow'"

# dotfiles
alias dotfiles="git dotfiles"

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
