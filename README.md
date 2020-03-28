# shinter

Trace execv and execve via LD_PRELOAD

 - uses *embedded static perl* and executes *shpreload.pm::execve_()* on execve calls
 - $LD_PRELOAD=shpreload64.so bash -c 'ls'
 - read execve trace /tmp/report.txt: saving cwd, enviroment variables and execve args
 - precompiled so in rel/*
 - (can be adopter to overload other symbols)

Build:

$ make all
