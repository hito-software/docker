#!/usr/bin/env sh

if [[ "$AUTOSTART_SEED_PERMISSIONS" == 1 ]]; then
  supervisorctl start seed-permissions
fi

exit 0
