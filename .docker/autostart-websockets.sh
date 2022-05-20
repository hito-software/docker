#!/usr/bin/env sh

if [[ "$AUTOSTART_WEBSOCKETS" == 1 ]]; then
  supervisorctl start websockets
fi

exit 0
