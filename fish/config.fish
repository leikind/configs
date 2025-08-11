# ~/.config/fish/config.fish

### <GETTING BACK TO THE PREVIOUS DIRECTORY>  ###

function chpwd --on-variable PWD --description 'handler of changing $PWD'
  if not status --is-command-substitution
    and status --is-interactive
    echo $PWD >$HOME/.current-project
  end
end

get_back_to_last_used_dir

### </GETTING BACK TO THE PREVIOUS DIRECTORY>  ###

####  <PATHS> ####

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
set -gx --append PATH /Users/leikind/bin
set -gx --append PATH /usr/local/bin
set -gx --append PATH /Users/leikind/.cargo/bin

set -gx --prepend PATH /opt/homebrew/bin/
set -gx --prepend PATH /opt/homebrew/sbin/


####  <VARS> ####

set -x LC_CTYPE en_US.UTF-8
set -x EDITOR micro
set -x GREP_OPTIONS '--color=auto'
set -x PAGER less
set -x LESS -R
set -x LESSOPEN ' | ~/.lessfilter %s'
set -x LSCOLORS ""
set -x GOPATH /Users/leikind/projects/golang

set -x LANG "en_US.UTF-8"

# iex / erl command history
set -x ERL_AFLAGS "-kernel shell_history enabled"

# We've reduced the time we count an escape character as alt.
# In terminals there is no other way to distinguish between e.g.
# pressing escape, then pressing a and pressing alt+a.
# If you want, you can change it by setting $fish_escape_delay_ms
# to a higher value, e.g. > 100ms
set -gx fish_escape_delay_ms 150

# <Postgresql>
set -gx LDFLAGS "-L/opt/homebrew/opt/postgresql@14/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/postgresql@14/include"
# set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/postgresql@14/lib/pkgconfig"
# </Postgresql>

####  </VARS> ####

### <ALIASES>  ###

alias gp "git pull origin"
alias f "fork"
alias z "zed ."
alias rspec "rspec -c"
alias ls "ls -G"
alias less "less -N"
alias gitx 'gitx .'
alias grepl 'grep  --line-number'
alias logd "tail -f log/development.log"
alias logp "tail -f log/production.log"
alias logt "tail -f log/test.log"
alias duf 'du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias docker_image_purge 'docker rmi -f $(docker images -aq)'

alias openports 'lsof -i -P | grep -i "listen"'
alias be 'bundle exec'
alias r './docker/development/run'
### </ALIASES>  ###

fzf --fish | source

### <VERSION MANAGERS>  ###

# The way I did it before
# source /opt/homebrew/opt/asdf/libexec/asdf.fish

# < ASDF: from https://asdf-vm.com/guide/getting-started.html >
if test -z $ASDF_DATA_DIR
  set _asdf_shims "$HOME/.asdf/shims"
else
  set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
# YL: The version on the ASDF website does this only
# if $PATH does not contains $_asdf_shims, but for
# some weird reason in the Zed terminal the order of items
# is messed up, so I always prepend the path to ASDF shims
set -gx --prepend PATH $_asdf_shims

set --erase _asdf_shims

# </ ASDF: from https://asdf-vm.com/guide/getting-started.html >


### </VERSION MANAGERS>  ###
