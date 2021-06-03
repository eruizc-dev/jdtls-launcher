## JDTLS - Launcher

The simplest way to install and launch Eclipse's JDTLS!!

### Requirements

 - Linux, MacOS or WSL
 - `java` is available in path
 - `openjdk` version 11 or higher

### Installation

**IMPORTANT:** Manually delete any previous installation using `rm -rf`

**User Level installation** (installs in `~/.local/lib`, does not require sudo)

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | bash
```

**System Level installation** (installs in `/usr/local/lib`)

```sh
curl https://raw.githubusercontent.com/eruizc-dev/jdtls-launcher/master/install.sh | sudo bash
```

For custom location check [advanced installation](./INSTALL.md)

### Editor configuration:

 - **Neovim**:
    - [nvim-lspconfig](./INSTALL.md#neovim-with-lspconfig)
