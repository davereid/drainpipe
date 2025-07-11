#!/bin/bash
# DO NOT EDIT THIS FILE
# This file is controlled by Drainpipe, run composer install to apply pending
# updates.

set -eux
echo "Updating..."

#drainpipe-start
mv .tugboat .tugboat-tmp
#drainpipe-end
composer install
./vendor/bin/task sync

# Ensure the sites/default directory is writable.
chmod 755 ${DOCROOT}/sites/default

# Set file permissions such that Drupal will not complain.
chgrp -R www-data "${DOCROOT}/sites/default/files"
find "${DOCROOT}/sites/default/files" -type d -exec chmod 2775 {} \;
find "${DOCROOT}/sites/default/files" -type f -exec chmod 0664 {} \;
#drainpipe-start
./vendor/bin/drush config:export --yes
rm -rf .tugboat
mv .tugboat-tmp .tugboat
#drainpipe-end
