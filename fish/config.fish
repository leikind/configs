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

# normally source /opt/homebrew/opt/asdf/libexec/asdf.fish should do this
# but in VSCode it does not work for some reason
# fish_add_path -ag /Users/leikind/.asdf/shims

fish_add_path -ag /Users/leikind/bin
fish_add_path -ag /usr/local/bin
fish_add_path -ag /opt/homebrew/bin/
fish_add_path -ag /opt/homebrew/sbin/
fish_add_path -ag /Users/leikind/.cargo/bin


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
### </ALIASES>  ###

fzf --fish | source

### <VERSION MANAGERS>  ###

source /opt/homebrew/opt/asdf/libexec/asdf.fish

### </VERSION MANAGERS>  ###
