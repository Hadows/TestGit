#!/bin/bash
set -ex

RUN_FLUXBOX=${RUN_FLUXBOX:-yes}
RUN_TERMINAL=${RUN_TERMINAL:-yes}

case $RUN_FLUXBOX in
  false|no|n|0)
    rm -f /app/config/system-fluxbox.conf
    ;;
esac

case $RUN_TERMINAl in
  false|no|n|0)
    rm -f /app/config/xterm.conf
    ;;
esac

exec supervisord -c /app/supervisord.conf

