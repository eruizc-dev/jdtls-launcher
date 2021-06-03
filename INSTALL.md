# JDTLS Launcher installation manual

## Confirmed functionality in

 - Linux: Manjaro Linux
 - MacOS: BigSur
 - Windows: Ubuntu WSL2

## Uninstall

 1. Search for symlinks and delete them
    `where jdtls | sudo rm`
 2. Delete install locations, commonly under `/usr/local/lib/jdtls-launcher` or
 `~/.local/lib/jdtls-launcher`
    `sudo rm -rf /usr/local/lib/jdtls-launcher ~/.local/lib/jdtls-launcher`

## Install

### TLDR installation

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash
```

### Via install script

**User Level installation** (installs in `~/.local/lib`, does not require sudo)

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash
```

**System Level installation** (installs in `/usr/local/lib`)

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash
```

**Custom location installation**
You can pass a parameter to the `install.sh` script with a custom install
location. That's the final directory the script will use. Example:

```bash
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash -s /usr/lib/jdtls-launcher
```

### Manual installation

 1. Put the `jdtls-launcher.sh` file wherever you want
 2. Execute the file passing it `--install` option

## Editor set-up

#### Neovim with [lspconfig](https://github.com/neovim/nvim-lspconfig)

 1. Install lspconfig the way you like (check lspconfig or your plugin manager
 documentation on how to install)
 2. In your vimrc add the following:
 ```vim
 lua require'lspconfig'.jdtls.setup{
 \   cmd = { 'jdtls' },
 \   root_dir = function(fname)
 \      return require'lspconfig'.util.root_pattern('pom.xml', 'gradle.build', '.git')(fname) or vim.fn.getcwd()
 \   end
 \}
 ```
