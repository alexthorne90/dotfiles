# Alex Thorne's dotfile stuff

## Setup

* `./install-dotfiles.sh`
  * This copies your current dotfiles into backups (with dates) and then symlinks and sources the repo files to your $HOME
* It doesn't work on windows...  This is super annoying but it looks like running `ln -s` in bash on windows just copies the file.  The link doesn't work.  Here's how to make a link in windows
  * Enter command prompt (cmd.exe) as a admin
  * `mklink C:\Users\Alex\.bashrc C:\Users\Alex\githubcode\dotfiles\bashrc`
    * This is the windows command for sym link.  Notice that the order is backward
  * I have not tried to script this yet, so for now you just have to link the files manually.
* Secrets - the bashrc references a `.bash_secrets` file and calls its function `export_secrets`.  If you need to export environmental secrets to your shell, manually add this file and create the function with whatever exports you want (don't commit the `.bash_secrets` file)

## The Tools

### Vim

- Using "vim-plug" : https://github.com/junegunn/vim-plug
  - Open up the vimrc and run `PlugInstall` to install plugins
- FZF : https://github.com/junegunn/fzf and https://github.com/junegunn/fzf.vim
  - These are powerful fuzzy-finder tools which will be automatically installed by the `PlugInstall` command.  Note that this will take over in your bash shell as well for commands like `c-R` (you want this, it's better)
  - bat : https://github.com/sharkdp/bat
    - A nicer `cat` which fzf uses in the background
- Asyncomplete : https://github.com/prabirshrestha/asyncomplete.vim
  - Asychronous autocomplete.  A lot of the tools in here are based on this.  Sources can be added to it's background task to feed into the completion list.  You'll see a lot of the vim plugins are "async-xxx" becasue they are used in this manner.
  - Fuzzy completion for asyncomplete : https://github.com/tsufeki/asyncomplete-fuzzy-match
    - This is an addon to the asyncomplete plugin that allows fuzzy matching.  It is a RUST app, so you'll need to have rust installed and the `cargo` command available in your path.  If you do, when running the `PlugInstall` it will automatically build and install the rust app for you.
- CTags : http://ctags.sourceforge.net/
  - Some of my vim plugins/commands rely on having the `ctags` command, which is a useful tagging tool (especially useful for C project).  Once you have this command executable in your path, run the `PlugInstall` command again to install these plugins.
- CoC : https://github.com/neoclide/coc.nvim
  - Conquer of Completion, a Node-y way of adding powerful tools to your vim
  - Many additional CoC plugins are used and connect CoC to different language servers
- Testing
  - Using vim-test plugin to automatically determine how to run unit tests based on the file type.  These are then dependent on having that test runner available (`pytest` for example).
  - Ceedling : http://www.throwtheswitch.org/ceedling.  Using the Ruby gem for C testing (this overrides the vim-test settings).  `ceedling` command must be available in path for this: `gem install ceedling`.

### Bash

- FZF : https://github.com/junegunn/fzf
  - As described above, this is a powerful fuzzy-finder tool that will be installed for you during your vim plugin installation
- ripgrep : https://github.com/BurntSushi/ripgrep
  - A powerful grep helper



### TODOs

Recently changed my vim setup from using ALE and other tools over to using CoC.  This seems like a solution that can be better for handling all languages with one plugin, but I definitely don't yet have things optimized for python or C.

