# -----------------------------------------------------
# ADDING TO THE PATH
# -----------------------------------------------------

# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin $HOME/.config/emacs/bin $HOME/Applications /var/lib/flatpak/exports/bin/ $fish_user_paths

# -----------------------------------------------------
# EXPORT
# -----------------------------------------------------

set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type
set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal
set VISUAL "emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode

# -----------------------------------------------------
# SET MANPAGER
# -----------------------------------------------------

### Uncomment only one of these!

### "nvim" as manpager
set -x MANPAGER "nvim +Man!"

### "less" as manpager
# set -x MANPAGER "less"

# -----------------------------------------------------
# SET EITHER DEFAULT EMACS MODE OR VI MODE
# -----------------------------------------------------

function fish_user_key_bindings
  # fish_default_key_bindings
  fish_vi_key_bindings
end

# -----------------------------------------------------
# AUTOCOMPLETE AND HIGHLIGHT COLORS
# -----------------------------------------------------

set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

# scripts
alias h='~/install/scripts/h'
alias hu='~/install/scripts/hosts/update_hosts.sh'
alias sshp='~/install/scripts/ssh/sshp'
alias fortiup='~/install/scripts/forti_up'
alias fortidown='~/install/scripts/forti_down'
alias xr='~/install/scripts/xrandr/xr.sh'
alias rdp_win11='~/install/scripts/rdp_win11'
alias sony_to_a2dp='~/install/scripts/sony_to_a2dp.sh'
alias sony_to_headset='~/install/scripts/sony_to_headset.sh'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim and emacs
alias vim='nvim'

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# pacman and yay
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages (DANGEROUS!)

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# switch between shells
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# bare git repo alias for dotfiles
alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# -----------------------------------------------------
# SETTING THE STARSHIP PROMPT
# -----------------------------------------------------

starship init fish | source

# -----------------------------------------------------
# PYWAL
# -----------------------------------------------------

cat ~/.cache/wal/sequences

# -----------------------------------------------------
# PFETCH
# -----------------------------------------------------

echo ""
pfetch
