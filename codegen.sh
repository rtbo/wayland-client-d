#! /bin/bash


function usage {
    echo "codegen.sh:"
    local RET=0
    if [ -n "$1" ]; then
        echo "    $1"
        echo
        RET=1
    fi
    echo "Wayland D bindings code generator"
    echo "usage: $0 [Protocol] [Scanner]"
    echo "   [Protocol]: Protocol XML file (mandatory)"
    echo "   [Scanner]:  wayland-scanner-d program path (defaults to wayland-scanner-d)"
    exit $RET
}


if [ $# -lt 1 ]; then
    usage "too few arguments supplied"
fi

if [ $# -gt 2 ]; then
    usage "too many arguments supplied"
fi

PROTOCOL=$1
SCANNER=wayland-scanner-d
SRC="`dirname $0`/src"

if [ ! -r $PROTOCOL ]; then
    usage "$PROTOCOL is not readable"
fi

if [ $# -eq 2 ]; then
    SCANNER=$2
    if [ ! -x $SCANNER ]; then
        usage "$SCANNER is not executable"
    fi
else
    command -v wayland-scanner-d >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        usage "Could not find wayland-scanner-d in \$PATH"
    fi
fi




cat $PROTOCOL | $SCANNER -m wayland.client.protocol \
        --client --protocol -o $SRC/wayland/client/protocol.d \
        -x wayland.client.core -x wayland.client.ifaces

cat $PROTOCOL | $SCANNER -m wayland.client.ifaces \
        --client --ifaces --ifaces_priv_mod wayland.client.priv.ifaces \
        -o $SRC/wayland/client/ifaces.d

cat $PROTOCOL | $SCANNER -m wayland.client.priv.ifaces \
        --client --ifaces --ifaces_priv \
        -o $SRC/wayland/client/priv/ifaces.d
