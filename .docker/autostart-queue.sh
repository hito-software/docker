#!/usr/bin/env sh

if [[ "$AUTOSTART_QUEUE" == 1 ]]; then
  supervisorctl start queue:*
fi

exit 0
