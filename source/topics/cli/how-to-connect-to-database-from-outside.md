Aptible databases are hosted inside a private subnet in the AWS cloud. As a result, they're not accessible from the public internet.

To connect to your Aptible database from outside Aptible's private cloud, use the `aptible db:tunnel` command:

    aptible db:tunnel $DB_HANDLE

This will create a secure (SSH) tunnel to your database and print a local URL where you can connect to the database.

You can look up the handle for your database on the [Aptible Dashboard](https://dashboard.aptible.com).
