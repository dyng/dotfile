# setting screenshots' path
if [[ ! -e $HOME/Screenshots ]]; then
    mkdir $HOME/Screenshots
fi
defaults write com.apple.screencapture location $HOME/Screenshots/

# setting key repeat
# normal minimum is 15 (225 ms)
defaults write -g InitialKeyRepeat -int 10 # 150ms

# normal minimum is 2 (30 ms)
defaults write -g KeyRepeat -int 1 # 15ms
