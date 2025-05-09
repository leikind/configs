# ~/.config/fish/functions/get_back_to_last_used_dir.fish

function get_back_to_last_used_dir
  if test -e $HOME/.current-project
    cd (cat $HOME/.current-project)
  end
end
