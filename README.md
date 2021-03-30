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
sudo -E jdtls && \
cd .. && \
rm -rf ./jdtls-launcher
```

Step by step:

 1. Clone the repo

    `git clone https://github.com/eruizc-dev/jdtls-launcher.git`

 2. Install jdtls launcher

    `sudo make install`

 3. Run jdtls and let it install the language server

    `sudo -E jdtls`

 4. If you end up with this json, you're good to go! You can delete the repo now

    ```json
    {"jsonrpc":"2.0","method":"window/logMessage","params":{"type":3,"message":"Mar 30, 2021, 7:54:47 PM Main thread is waiting"}}n^[n^[^[
    ```
