#!/usr/bin/env sh

if [[ "$AUTOSTART_COMPOSER_INSTALL" == 1 ]]; then
  supervisorctl start composer-install
elif [[ "$AUTOSTART_COMPOSER_UPDATE" == 1 ]]; then
  supervisorctl start composer-update
fi

exit 0
