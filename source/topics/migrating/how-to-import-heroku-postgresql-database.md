Once you have provisioned and deployed a copy of your app on Aptible, there are a few final steps to migrate from Heroku's managed PostgreSQL service:

1. First, put your Heroku app into maintenance mode:

        heroku maintenance:on -a $HEROKU_APP_HANDLE

1. Manually trigger a backup of your Heroku database:

        heroku pgbackups:capture --expire -a $HEROKU_APP_HANDLE

1. View the list of backups, noting the ID for the backup you just created:

        heroku pgbackups -a $HEROKU_APP_HANDLE

1. Get the URL for your backup:

        heroku pgbackups:url $BACKUP_ID -a $HEROKU_APP_HANDLE

1. Open an Aptible SSH session:

        aptible ssh --app $APTIBLE_APP_HANDLE

1. Download the backup file, using the URL from Step 4:

        wget $BACKUP_URL -O backup.dump

1. Install the PostgreSQL command line tools in your aptible ssh image, if they aren't already installed:

        apt-get -y install postgresql-client-9.3 postgresql-contrib-9.3

1. Restore from the backup:

        pg_restore --clean --no-acl --no-owner $DATABASE_URL backup.dump
