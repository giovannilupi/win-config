# Colors
_prompt_bold_red='\[\033[1;31m\]'
_prompt_bold_green='\[\033[1;32m\]'
_prompt_gray='\[\033[0;37m\]'
_prompt_teal='\[\033[0;36m\]'
_prompt_reset='\[\033[0m\]'

function _theme_PROMPT_COMMAND {
  if (($? != 0)); then local border_color=$_prompt_bold_red
  else local border_color=$_prompt_bold_green
  fi
  local branch=""
  # Check if inside a Git repository
  if branch=$(git symbolic-ref --short -q HEAD 2>/dev/null); then branch="${_prompt_gray}${branch}${_prompt_reset} "; fi
  PS1="${_prompt_teal}\w${_prompt_reset} ${branch}${border_color}❯${_prompt_reset} "
}

# Set the PROMPT_COMMAND
PROMPT_COMMAND=_theme_PROMPT_COMMAND