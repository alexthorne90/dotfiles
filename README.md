# Alex Thorne's dotfile stuff

## Setup

* `./install-dotfiles.sh`
  * This copies your current dotfiles into backups (with dates) and then symlinks and sources the repo files to your $HOME

## The Tools

### Vim

- Using "vim-plug" : https://github.com/junegunn/vim-plug
  - Open up the vimrc and run `PlugInstall` to install plugins
- FZF : https://github.com/junegunn/fzf and https://github.com/junegunn/fzf.vim
  - These are powerful fuzzy-finder tools which will be automatically installed by the `PlugInstall` command.  Note that this will take over in your bash shell as well for commands like `c-R` (you want this, it's better)
  - bat : https://github.com/sharkdp/bat
    - A nicer `cat` which fzf uses in the background
- CTags : http://ctags.sourceforge.net/
  - Some of my vim plugins/commands rely on having the `ctags` command, which is a useful tagging tool (especially useful for C project).  Once you have this command executable in your path, run the `PlugInstall` command again to install these plugins.
- PyLS : Python Language Server : https://pypi.org/project/pyls/
  - This is a powerful tool for python development which runs a python server in a separate thread that provides information to the vim editor.  It must be installed separately with `pip`
  - `pip install pyls`
- ALE : https://github.com/dense-analysis/ale
  - Asychronous Lint Engine, provides code linting and fixing commands.  This is installed through the plugin manager, but can rely on external commands being available.  In a vim buffer, use the command `ALEInfo` to get help.
  - Current dependencies:
    - flake8 : `pip install flake8`
    - autopep8 : `pip install autopep8`
    - pyls : `pip install pyls`
    - Omnisharp : will be installed through your vim plugins
    - eslint : https://www.npmjs.com/package/eslint
- Testing
  - Using vim-test plugin to automatically determine how to run unit tests based on the file type.  These are then dependent on having that test runner available (`pytest` for example).
  - Ceedling : http://www.throwtheswitch.org/ceedling.  Using the Ruby gem for C testing (this overrides the vim-test settings).  `ceedling` command must be available in path for this: `gem install ceedling`.

### Bash

- FZF : https://github.com/junegunn/fzf
  - As described above, this is a powerful fuzzy-finder tool that will be installed for you during your vim plugin installation
- ripgrep : https://github.com/BurntSushi/ripgrep
  - A powerful grep helper

