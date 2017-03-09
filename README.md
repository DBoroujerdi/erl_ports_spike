# Erlang ports spike

A spike to demonstrate Erlang ports.

The following to_upper and to_lower functions call a C program to perform the upper and lower computation over an Erlang port managed by a supervisor. This example is heavity based on the Erlang ports tutorial at http://erlang.org/doc/tutorial/c_port.html.

``` shell
make

make shell

Erlang/OTP 18 [erts-7.2.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:true] [dtrace]

Eshell V7.2.1  (abort with ^G)
(erl_port_spike@Daniels-MacBook-Pro)2> erl_port_spike:to_upper("daniel").
"DANIEL"

(erl_port_spike@Daniels-MacBook-Pro)3> erl_port_spike:to_lower("DANiel").
"daniel"
```
