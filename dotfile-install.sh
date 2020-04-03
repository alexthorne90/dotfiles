#!/bin/sh

while true; do
    read -p "Do you want to install the dotfiles (y/n)?  They will overwrite any files with the same names" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Setting bash profile..."
cp bash_profile ~/.bash_profile
source ~/.bash_profile

echo "Setting vimrc..."
cp vimrc ~/.vimrc
source ~/.vimrc

echo "Copying vim snippets..."
mkdir -p ~/.vim/ultisnips
cp .vim/ultisnips/* ~/.vim/ultisnips/.
