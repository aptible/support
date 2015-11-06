Aptible databases are hosted inside a private subnet in the AWS cloud. As a result, they're only accessible from a secure tunnel.

To connect to your Aptible database from outside Aptible's private cloud, use the `aptible db:tunnel` command:

    aptible db:tunnel $DB_HANDLE

This will create a secure (SSH) tunnel to your database and print a local URL where you can connect to the database.

Open a separate terminal window and, depending on the database type:

- Pass in the entire URL, e.g. 

      psql postgresql://aptible:[PASSWORD]@127.0.0.1:[PORT]/db

OR

- Use the port, host, user, and password contained within the connection URL, e.g.

      mongo localhost:[PORT]/db -u aptible -p [PASSWORD]

For non-CLI database clients, the required arguments are the same:

      Host: 127.0.0.1 
      Port: [PORT]
      Username: aptible
      Password: [PASSWORD]
      Database: db
