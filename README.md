## JDTLS - Launcher

The simplest way to install and launch Eclipse's JDTLS!!

 - [Requirements](#requirements)
 - [Installation](#installation)
    - [MacOS](#macos-installation)
    - [Linux / WSL](#linux-%2F-wsl-installation)
    - [Manual Installation](#manual-installation)
 - [Updating](#updating)
 - [Uninstall](#uninstall)
 - [Editor configuration](#editor-configuration)
    - [Neovim with lspconfig](#neovim-with-lspconfig)

---

### Requirements:

 - Java 11 (available in path)
 - Linux, MacOS or WSL

### Install

**IMPORTANT:** [uninstall](#uninstall) any previous installation

#### MacOS Installation

**System level installation**:
 - Installs in `/usr/local/lib/jdtls-launcher`
 - Creates symlink in `/usr/local/bin`

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash
```

#### Linux / Wsl Installation

**System Level installation**
 - Installs in `/usr/local/lib/jdtls-launcher`
 - Creates symlink in `/usr/local/bin`

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash
```

**User Level installation**
 - Installs in `~/.local/lib/jdtls-launcher`
 - Creates symlink in `~/.local/bin`

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash
```

#### Manual Installation

 1. Choose a destination to install. Avoid PATH locations since the script
    installs dependencies alongside it.
 2. Create a symlink in your path if you need it
 3. Run the script with `--install` option, this will install all dependencies

#### Aditional options

**Custom location**
 - Append `-s /path/to/folder` to either system or user installation
 - The script won't create any extra directories, so make sure you finish it
`jdtls-launcher`
 - Symlinks will still be created to their respective destinations

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash -s /usr/lib/jdtls-launcher
```

### Update

To update jdtls and lombook it's as simple as `jdtls --update`

You can always check what version you have installed with `jdtls --version`
command.

To update jdtls-launcher you have to manually [uninstall](#uninstall) and
[reinstall](#install)

### Uninstall

Remove symlink and `jdtls-launcher` directory with `rm -rf`.
 - You can find the directory following the symlink with `dirname $(realpath jdtls)`
 - You can find the symlink locatin with `where jdtls`

### Editor configuration:

#### Neovim with [lspconfig](https://github.com/neovim/nvim-lspconfig)

In your vimrc add the following:

```vim
lua require'lspconfig'.jdtls.setup{
\   cmd = { 'jdtls' },
\   root_dir = function(fname)
\      return require'lspconfig'.util.root_pattern('pom.xml', 'gradle.build', '.git')(fname) or vim.fn.getcwd()
\   end
\}
```
