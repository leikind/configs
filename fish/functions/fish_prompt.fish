# ~/.config/fish/functions/fish_prompt.fish

function my_prompt_pwd --description 'Print the current working directory, NOT shortened to fit the prompt'
  if test "$PWD" != "$HOME"
    printf "%s" (echo $PWD|sed -e 's|/private||' -e "s|^$HOME|~|")
  else
    echo '~'
  end
end

function fish_prompt --description 'Write out the prompt'
  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  if not set -q __git_cb
    set __git_cb ":"(set_color brown)(git branch 2> /dev/null | grep \* | sed 's/* //')(set_color normal)""
  end

  switch $USER
    case root

      if not set -q __fish_prompt_cwd_color
        if set -q fish_color_cwd_root
          set -g __fish_prompt_cwd_color (set_color $fish_color_cwd_root)
        else
          set -g __fish_prompt_cwd_color (set_color $fish_color_cwd)
        end
      end
      printf '%s@%s:%s%s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd_color" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

    case '*'
      if not set -q __fish_prompt_cwd_color
        set -g __fish_prompt_cwd_color (set_color $fish_color_cwd)
      end
      printf '%s:%s%s%s%s → ' $USER "$__fish_prompt_cwd_color" (my_prompt_pwd) "$__fish_prompt_normal" $__git_cb
  end
end
