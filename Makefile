PROJECT = erl_port_spike
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

C_SRC_DIR = $(CURDIR)/c_src

SHELL_OPTS = \
    +P 5000000 \
    +K true \
    -pa ebin \
    -s erl_port_spike \
    -sname erl_port_spike

C_SRC_TYPE = executable

include erlang.mk
