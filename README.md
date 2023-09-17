# JDTLS - Launcher

JDTLS Launcher was a simple script that allowed you to easily install and execute
[Eclipse's JDT Language Server](https://github.com/eclipse-jdtls/eclipse.jdt.ls#).
It included awesome features like updates, and backups, and
[Lombok](https://projectlombok.org/) configuration.

# Deprecation notice

As better alternatives keep appearing, this project was archived on September 17 2023.

This script works and will continue working for a while, but if you run into any issues
I suggest migrating to your favorite package manager. Some examples:

 - [Nix](https://search.nixos.org/packages?channel=unstable&show=jdt-language-server&from=0&size=50&sort=relevance&type=packages&query=jdt-language-server)
 - [Homebrew](https://formulae.brew.sh/formula/jdtls)
 - [Arch User Repository](https://aur.archlinux.org/packages/jdtls)
 - [Mason.nvim](https://mason-registry.dev/registry/list#jdtls)

## Uninstall

Remove symlink and `jdtls-launcher` directory with `rm -rf`.
 - Install location can be found using `dirname $(realpath jdtls)`
 - Symlink locations can be found using `where jdtls` or `which jdtls`
