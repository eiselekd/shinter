# shinter

Trace execve via LD_PRELOAD

 - $LD_PRELOAD=shpreload64.so bash -c 'ls'
 - read execve trace /tmp/report.txt: saving cwd, enviroment variables and execve args
 - uses embedded static perl and executes shpreload.pm::execve_() on execve calls
 - precompiled so in rel/*

Build:

$ make all
