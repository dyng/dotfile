# setting screenshots' path
if [[ ! -e $HOME/Screenshots ]]; then
    mkdir $HOME/Screenshots
fi
defaults write com.apple.screencapture location $HOME/Screenshots/
