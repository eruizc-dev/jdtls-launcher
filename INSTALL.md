## JDTLS Launcher install manual

### Supported systems

 - Linux
 - MacOS (BigSur)
 - Windows Subsystem For Linux (WSL)

### Remove older installations

In case of conflict you may want to remove old jdtls installations. By default they're
installed to `$JAVA_HOME/../jdtls`, so you can simply force delete that directory.

```bash
sudo rm -rf "$JAVA_HOME/../jdtls"
```

### Configure JAVA_HOME

`JAVA_HOME` is an environment variable where java binaries are stored. It's used to
indicate where the java virtual machine binary is, which should be under
`"$JAVA_HOME/bin/java"`.

 - If you have the executable `java` you can run `where java` to find the installation,
 remove the `/bin/java` part and that's the value you want.



### FAQ
