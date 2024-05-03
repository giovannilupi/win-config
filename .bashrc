# Exported variables
export USER=USERNAME
export BAT_THEME=gruvbox-dark

# ble.sh setup
[[ $- == *i* ]] && source ~/ble-0.4.0-devel3/ble.sh --noattach

# Source files
[ -f ~/.theme.sh ] && source ~/.theme.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Aliases
alias vm="ssh -q -t USERNAME@VM_IP \"/path/to/fastfetch; zsh\""
alias cat="bat -p -P"
alias ls="eza --icons --group-directories-first"
alias ll="eza --long --icons --group-directories-first"
alias la="eza --long --icons --group-directories-first -a"

# Function to open a file in Sublime Text
subl() {
    (/c/Program\ Files/Sublime\ Text/sublime_text.exe "$@" &)
}

# Function to jump to a directory
jmp() {
  selected=$(echo -e "$(<~/.jmp)" | fzf -e --ansi --reverse --color "hl:-1:underline,hl+:-1:underline:reverse" --height='80%') || return 0
  selected="$(cut -d " " -f2- <<< "$selected")"
  declare -A alias_map
  alias_map=(
    ["home"]="${HOME}"
    ["documents"]="${HOME}/Documents"
    ["downloads"]="${HOME}/Downloads"
    ["regressiontestsuite"]="${HOME}/projects/regressiontestsuite"
    ["vm"]="/z"
  )
  cd "${alias_map[$selected]}"
}

# Function to open a project in VS Code using the remote ssh extension
gtp() {
  selected=$(echo -e "$(<~/.projects)" | fzf -e --ansi --reverse --color "hl:-1:underline,hl+:-1:underline:reverse" --height='80%') || return 0
  selected="$(cut -d " " -f2- <<< "$selected")"
  code --folder-uri "vscode-remote://ssh-remote+USERNAME@VM_IP/path/to/repos/$selected"
}

# Function to display git diff with delta
gd() {
    diff_output=$(git diff "$@")
    if [ -n "$diff_output" ]; then echo "$diff_output" | delta -s --navigate --wrap-max-lines 2 --pager bat; fi
}

# Function to add files to git
ga() {
    files=$(git status --porcelain | awk '{
        if ($1 == "M") {  # Modified files
            printf "\033[31m%s\033[0m\n", $2
        } else if ($1 == "??") {  # Untracked files
            printf "\033[90m%s\033[0m\n", $2
        }
    }')
    if [ -n "$files" ]; then
        selected_branch=$(echo "$files" | fzf --ansi -e --reverse --height 80% -m)
        if [ -n "$selected_branch" ]; then git add $selected_branch; fi
    fi
}

# Function to switch git branches
gcb() {
    branches=$(git branch)
    if [ -n "$branches" ]; then
        selected_branch=$(echo "$branches" | fzf -e --reverse --height 80% +m)
        if [ -n "$selected_branch" ]; then git switch $selected_branch; fi
    fi
}

# Function to checkout files
gcf() {
    files=$(git diff --name-only)
    if [ -n "$files" ]; then
        selected_branch=$(echo "$files" | fzf -e --reverse --height 80% -m)
        if [ -n "$selected_branch" ]; then git checkout $selected_branch; fi
    fi
}

# ble.sh setup
[[ ${BLE_VERSION-} ]] && ble-attach
