---
title: Go on Aptible
---

This guide teaches you how to set up a Websockets-based chat server written in
Go on Aptible, using the Gorilla web toolkit.  With additional authentication,
authorization, and data persistence, this example app has the potential to
become a HIPAA-compliant web chat product that might command millions of
dollars in seed funding.


# Materials
- Recent version of git installed
- Modern web browser with websockets


# Get the code
```bash
$ git clone https://github.com/wyc/aptible-go-websockets-chat
$ cd aptible-go-websockets-chat
```

# Look around
- Dockerfile: Sets up the image that will contain the app. It currently
installs Go 1.3.2 and some command line utilities to compile and install
the project and its dependencies.
`CMD` is ignored by Aptible but included for convention
- Procfile: Aptible reads this file to determine what to run. You can specify
multiple jobs, but this project did not
- *.go: Application code
- *.html: The served HTML template

# Deploy to Aptible
1. Login to https://aptible.com and set up a dev or prod app with any
valid handle.
2. Add the Aptible remote and push to it to deploy.

    ```bash
    $ git remote add aptible git@beta.aptible.com:<YOUR_APP_HANDLE>.git
    $ git push aptible master
    ```
3. Click the app name in the Aptible Apps dashboard to get to the details
page. Add a VHOST. If you do not have an issued SSL cert, you can self-sign
your own using one of the many guides on the internet. Alternatively, you can
use [this website](http://www.selfsignedcertificate.com/) to generate a
self-signed cert for a specified virtual domain. DO NOT DO THIS FOR YOUR
PRODUCTION APP. GET AN AUTHORITY-ISSUED SSL CERT FOR PRODUCTION.
4. Do not store PHI on dev apps.
5. Do not store PHI on dev apps.
6. Access the chat server from the VHOST URL that should look something like:

```
https://app-handle-web-pqpaef-357192381.us-east-3.elb.amazonaws.com/
```


# Additional steps for your apps

## Databases
Attaching a database is easy as the networking is already setup for you.

1. Request a database of your choice via the Aptible dashboard or CLI tool.
2. Set (an) environmental variable(s) with database connection info.

    ```bash
    $ gem install aptible-toolbelt
    $ aptible login
    $ aptible config:add --app APP-HANDLE DATABASE_URL=<URL_FROM_DATABASE_PAGES_ON_DASHBOARD>
    ```
3. Use those env variables to connect to the database:

    ```go
    databaseURL := os.Getenv("DATABASE_URL")
    conn, err := db.Connect(databaseURL)
    ...
    ```

## API tokens

API tokens can be stored the app environmental variables via the
Aptible CLI tool just as the DATABASE_URL was set.

```bash
$ gem install aptible-toolbelt
$ aptible login
$ aptible config:add --app APP-HANDLE SENDGRID_USER=user SENDGRID_PASSWORD=hunter2
```

The environmental variable should now be accessible by your app:

```go
twilio := gotwilio.NewTwilioClient(os.Getenv("SENDGRID_USER"), os.Getenv("SENDGRID_PASSWORD"))
```

