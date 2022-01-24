#!/bin/sh

dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
datestr=$(date '+%Y-%m-%d_%H-%M')

while true; do
    read -p "Do you want to install the dotfiles (y/n)?  They will overwrite any files with the same names:  " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# create backups and sym links
vim_backup="vimrc_${datestr}"
echo "Backing up vimfile in home directory:$vim_backup"
mv ~/.vimrc ~/"$vim_backup"
echo "Linking .vimrc"
ln -s "$dirname"/vimrc ~/.vimrc
source ~/.vimrc

bashrc_backup="bashrc_${datestr}"
echo "Backing up vimfile in home directory:$bashrc_backup"
mv ~/.bashrc ~/"$bashrc_backup"
echo "Linking .bashrc"
ln -s "$dirname"/bashrc ~/.bashrc
source ~/.bashrc

bash_profile_backup="bash_profile_${datestr}"
echo "Backing up vimfile in home directory:$bash_profile_backup"
mv ~/.bash_profile ~/"$bash_profile_backup"
echo "Linking .bash_profile"
ln -s "$dirname"/bash_profile ~/.bash_profile
source ~/.bash_profile

# link snippets
echo "Copying vim snippets..."
mkdir -p ~/.vim/ultisnips
rm ~/.vim/ultisnips/*
SNIPPET_FILES="$dirname"/vim/ultisnips/*
for file in $SNIPPET_FILES
do
    echo "Linking snippet file: $file"
    ln -s "$file" ~/.vim/ultisnips
done

# link .clang-format in HOME
echo "Linking .clang-format"
ln -s "$dirname"/clang-format-alex-C ~/.clang-format

# link .prettierrc and .eslintrc in HOME
echo "Linking .prettierrc"
ln -s "$dirname"/prettierrc ~/.prettierrc
echo "Linking .eslintrc"
ln -s "$dirname"/eslintrc ~/.eslintrc
