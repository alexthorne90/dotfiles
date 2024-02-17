# Alex Thorne's dotfile stuff

## The Tools

### Neovim and Astronvim

- Neovim : https://neovim.io/
  - New age vim fork that makes plugins, API, and LSP usage easier than standard vim
- Astronvim : https://astronvim.com/
  - Pre-packaged Neovim configuration to get started quickly
  - Languages highlighting and basic usage through treesitter : https://github.com/nvim-treesitter/nvim-treesitter
    - `TSInstall c` to install the c languge treesitter extension
  - Similarly, formatting and linting is done through null-ls : https://github.com/jose-elias-alvarez/null-ls.nvim
    - `NullLsInstall autopep8` to install autopep8 for use
  - All package management with Maxon : https://github.com/williamboman/mason.nvim
- WIP
  - Super WIP here still, working on the user portion of the config to get this working.  Make sure to follow the linking install instructions below to link this repo's nvim configs into the astronvim user section
- Setup
  - A lot of things will install themselves when you first start nvim
  - Run :checkhealth to get good diagnostics
  - Python
    - https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim
    - Basically you want to set up a virtual python env specifically for Neovim
      - From the nvim root: `python -m venv ~/.virtualenvs/neovim311`
      - `python -m venv shell` -> `pip install pynvim neovim`
      - And then set g:python3_host_prog in vim options to point at the python executable in the venv

### Bash

- FZF : https://github.com/junegunn/fzf
  - These are powerful fuzzy-finder tools.  Note that this will take over in your bash shell as well for commands like `c-R` (you want this, it's better)
  - bat : https://github.com/sharkdp/bat
    - A nicer `cat` which fzf uses in the background
- ripgrep : https://github.com/BurntSushi/ripgrep
  - A powerful grep helper
- CTags : http://ctags.sourceforge.net/
  - still not sure if astronvim will need this or not


## Setup

* Install Neovim (see website above)
* Install Astronvim
  * Follow instructions from the website above
* `./install-dotfiles.sh`
  * This copies your current dotfiles into backups (with dates) and then symlinks and sources the repo files to your $HOME
* It doesn't work on windows...  This is super annoying but it looks like running `ln -s` in bash on windows just copies the file.  The link doesn't work.  Here's how to make a link in windows
  * Enter command prompt (cmd.exe) as a admin
  * `mklink C:\Users\Alex\.bashrc C:\Users\Alex\githubcode\dotfiles\bashrc`
    * This is the windows command for sym link.  Notice that the order is backward
    * Here's what I had to do for a directory to hold my custom astrovim lua config:
      `mklink /D C:\Users\AlexThorne\AppData\Local\nvim\lua\user C:\Users\AlexThorne\githubcode\dotfiles\lua-user`
      * !!! this is the important step to get my custom configs into astronvim
  * I have not tried to script this yet, so for now you just have to link the files manually.
* Secrets - the bashrc references a `.bash_secrets` file and calls its function `export_secrets`.  If you need to export environmental secrets to your shell, manually add this file and create the function with whatever exports you want (don't commit the `.bash_secrets` file)
* Window Terminal
  * The `settings.json` file in this repo is the windows terminal settings file.  To use this, copy it manually into the ridiculous path set up for windows terminal: `$LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\`
  * TODO: add this into the install script


## Language Specific

* Python
  * When using the pyright LSP in project with a virtual environment, it will need a pyrightconfig.json file to point the language server at the environment.  It will look something like this:
    ```
    {
        "venvPath": ".",
        "venv": ".venv"
    }
    ```

