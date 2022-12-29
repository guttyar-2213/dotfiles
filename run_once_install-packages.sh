{{ if eq .chezmoi.os "linux" -}}
#!/bin/bash
sudo apt install vim
{{ else if eq .chezmoi.os "darwin" -}}
#!/bin/bash
brew install vim
{{ end -}}

curl -fLo ~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim --create-dirs https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim
