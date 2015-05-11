Aptible databases are hosted inside a private subnet in the AWS cloud. As a result, they're only accessible from a secure tunnel.

To connect to your Aptible database from outside Aptible's private cloud, use the `aptible db:tunnel` command:

    aptible db:tunnel $DB_HANDLE

This will create a secure (SSH) tunnel to your database and print a local host and port where you can connect to the database.

Use the connection URL found on your [Aptible Dashboard](https://dashboard.aptible.com) to determine your database's handle, username, password, and name.  The connection URL is always of the form `$TYPE://$USERNAME:$PASSWORD@$INTERNAL_HOST:$INTERNAL_PORT/$DATABASE_NAME`.

When tunneling to your database, be sure to use the host and port listed in your terminal to connect to your database and not the internal host and port listed in your connection URL.