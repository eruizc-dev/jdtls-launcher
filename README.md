## JDTLS - Launcher

The simplest way to install and launch Eclipse's JDTLS!!

### Requirements

 - Linux, MacOS or WSL
 - `JAVA_HOME` is configured
 - `make` is installed

### Installation

TLDR:

```bash
git clone https://github.com/eruizc-dev/jdtls-launcher.git && \
cd jdtls-launcher && \
sudo make install && \
sudo -E jdtls --install && \
cd .. && \
rm -rf ./jdtls-launcher
```

Step by step:

 1. Clone the repo

    `git clone https://github.com/eruizc-dev/jdtls-launcher.git`

 2. Install jdtls launcher

    `sudo make install`

 3. Run jdtls and let it install the language server

    `sudo -E jdtls --install`

 4. Make sure it runs without issues. You can delete the repo now!

    `jdtls`
