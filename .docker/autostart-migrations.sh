#!/usr/bin/env sh

if [[ "$AUTOSTART_MIGRATIONS" == 1 ]]; then
  supervisorctl start migrations
fi

exit 0
