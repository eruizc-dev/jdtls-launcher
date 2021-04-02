# JDTLS Launcher installation manual

## Confirmed functionality in

 - Linux: Manjaro Linux
 - MacOS: BigSur
 - Windows: Ubuntu WSL2

## Uninstall

Everything is installed under `/usr/local/lib/jdtls-launcher` and a soft link is
created under `/usr/local/bin/jdtls`. Some eclipse stuff is stored in
`$HOME/workspace`. Remove them as you wish, or copy paste this:

`sudo rm -rf /usr/local/lib/jdtls-launcher /usr/local/bin/jdtls $HOME/workspace`

## Install

### Prequisites

 - `java` must be an accesible command. For that you will have to install Java 11 or higher.
 If you're in WSL and you installed Java from the Windows installer, you will need to install
 Java again but this time inside the Linux subsystem.

 - `git` must be installed.

 - `bash` must be installed.

### TLDR installation

```bash
git clone https://github.com/eruizc-dev/jdtls-launcher.git && \
cd jdtls-launcher && \
sudo bash -c ./install.sh && \
cd .. && \
rm -rf ./jdtls-launcher
```

### Step by step installation

From the Linux/MacOS command line execute the following commands:

 1. Clone the repo

    `git clone https://github.com/eruizc-dev/jdtls-launcher.git

 2. Navigate inside the repo directory

   `cd jdtls-launcher`

 3. Run the installation `install.sh` script with root privileges.

    `sudo bash -c ./install.sh`

 4. Run the `jdtls` command

    `jdtl`

 5. If the output looks like the folowing it means it's working. You can stop
 it by pressing CTRL+C.

    ```
    Listening for transport dt_socket at address: 1044
    WARNING: An illegal reflective access operation has occurred
    WARNING: Illegal reflective access by org.eclipse.osgi.internal.loader.ModuleClassLoader (file:/usr/local/lib/jdtls-launcher/jdtls/plugins/org.eclipse.osgi_3.16.200.v20210226-1447.jar) to method java.lang.ClassLoader.defineClass(java.lang.String,byte[],int,int)
    WARNING: Please consider reporting this to the maintainers of org.eclipse.osgi.internal.loader.ModuleClassLoader
    WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
    WARNING: All illegal access operations will be denied in a future release
    Content-Length: 125
    
    {"jsonrpc":"2.0","method":"window/logMessage","params":{"type":3,"message":"Apr 1, 2021, 9:30:02 PM Main thread is waiting"}}
    ```

 6. You can now delete the directory you've just created.

    - `cd ..`
    - `rm -r ./jdtls-launcher`

 7. Report anny issues during the isntallation process [HERE](https://github.com/eruizc-dev/jdtls-launcher/issues/new)

## Editor set-up

#### Neovim with [lspconfig](https://github.com/neovim/nvim-lspconfig)

 1. Install lspconfig the way you like (check lspconfig or your plugin manager
 documentation on how to install)
 2. In your vimrc add the following:
 ```vim
 lua require'lspconfig'.jdtls.setup{
 \   cmd = { 'jdtls' },
 \   root_dir = require'lspconfig'.util.root_pattern('pom.xml', 'gradle.build', '.git')
 \}
 ```
