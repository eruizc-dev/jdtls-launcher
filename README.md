# JDTLS - Launcher

The simplest way to install and launch Eclipse's JDTLS!!

 - [Requirements](#requirements)
 - [Installation](#installation)
    - [Automatic installation](#automatic-installation)
    - [Manual Installation](#manual-installation)
 - [Updating](#updating)
 - [Uninstall](#uninstall)
 - [Editor configuration](#editor-configuration)
    - [Neovim with lspconfig](#neovim-with-lspconfig)

---

## Requirements:

 - Java 11+ (available in path)
 - Linux, MacOS or WSL

## Installation:

### Automatic installation:

**Important**: [uninstall](#uninstall) any previous installation.

 - Script will be installed to `/usr/local/lib/jdtls-launcher`
 - A symlink called `jdtls` will be created in `/usr/local/bin`

##### Linux / WSL:

`curl -s https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash`

##### MacOS:

`curl -s https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash`

##### Custom install location:

Append `-s /path/to/dir` to the installation command
 - A directory called `jdtls-launcher` will be created inside that directory
 - Sudo may not be required
 - Symlinks won't be created

### Manual Installation:

 1. Download source code from [releases](https://github.com/eruizc-dev/jdtls-launcher/releases)
    or directly from the [master branch]()
 2. Unzip it and place `jdtls-launcher.sh` script in your desired install
    location
 3. Run the script with `--install` option to install jdtls and lombook
    alongside the script in a directory called `jdtls` (user must have write
    permissions)
 4. Run the script `jdtls-launcher.sh` without arguments to start the language
    server
 5. Optional: Add directory to path or create a symlink to a location in path

## Update

To update jdtls and lombook it's as simple as `jdtls --update`

You can always check what version you have installed with `jdtls --version`
command.

To update jdtls-launcher you have to manually [uninstall](#uninstall) and
[reinstall](#install)

## Uninstall

Remove symlink and `jdtls-launcher` directory with `rm -rf`.
 - Symlink locations can be found using `where jdtls` or `which jdtls`
 - Install location can be found using `dirname $(realpath jdtls)`

## Editor configuration:

#### Neovim with [lspconfig](https://github.com/neovim/nvim-lspconfig)

Add the following to your **init.vim**

```vim
lua require'lspconfig'.jdtls.setup{
\   cmd = { 'jdtls' },
\   root_dir = function(fname)
\      return require'lspconfig'.util.root_pattern('pom.xml', 'gradle.build', '.git')(fname) or vim.fn.getcwd()
\   end
\}
```
