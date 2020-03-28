# shinter

Trace execv

 - $LD_PRELOAD=shpreload64.so bash -c 'ls'
 - read execve trace /tmp/report.txt
 - uses embedded static perl and executes shpreload.pm::execve_() on execve calls
 - precompiled so in rel/*

