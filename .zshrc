# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  command-not-found
  zoxide
  fzf
  eza
  sudo
  zsh-interactive-cd
  autoupdate
)

ZOXIDE_CMD_OVERRIDE="cd"
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

eval "$(zoxide init zsh)"

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
source "$ZSH/oh-my-zsh.sh"

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='/usr/bin/nvim'
  export VISUAL='/usr/bin/nvim'
fi


# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

# Aliases
alias dotfiles="git dotfiles"

alias nix-gc="sudo nix-collect-garbage -d"
alias nix-rebuild="sudo nixos-rebuild switch --flake $HOME/.nix"
alias home-rebuild="home-manager switch --flake $HOME/.nix"
alias flake-update="sudo nix flake update --flake $HOME/.nix"




# ZSH Config goes above this line.

precmd() { export LAST_EXIT_CODE=$? }

#eval "$(oh-my-posh init zsh --config '~/.config/omp.json')"
eval "$(starship init zsh)"

precmd_functions=(zvm_init "${(@)precmd_functions:#zvm_init}")
precmd_functions+=(set-long-prompt)
zvm_after_init_commands+=("zle -N zle-line-finish; zle-line-finish() { set-short-prompt }")

set-long-prompt() {
    PROMPT=$(starship prompt)
    RPROMPT="$(starship prompt --right)"
}

export COLUMNS=$(($COLUMNS + ($COLUMNS*0.1)))
set-short-prompt() {
  if [[ $PROMPT != '%# ' ]]; then
    PROMPT="$(starship prompt --profile transient)"
    RPROMPT=""
    zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
  fi
}
zle-keymap-select() {
    set-short-prompt
}
zle -N zle-keymap-select

zle-line-finish() { set-short-prompt }
zle -N zle-line-finish

trap 'set-short-prompt; return 130' INT

# try to fix vi mode indication (not working 100%)
zvm_after_init_commands+=('
  function zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] ||
       [[ $1 = "block" ]]; then
      echo -ne "\e[1 q"
      STARSHIP_KEYMAP=vicmd
    elif [[ ${KEYMAP} == main ]] ||
         [[ ${KEYMAP} == viins ]] ||
         [[ ${KEYMAP} = "" ]] ||
         [[ $1 = "beam" ]]; then
      echo -ne "\e[5 q"
      STARSHIP_KEYMAP=viins
    fi
    zle reset-prompt
  }
  zle -N zle-keymap-select

  # Ensure vi mode is set
  zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
  }
  zle -N zle-line-init
')




clear
fastfetch
