This guide teaches you how to set up a Websockets-based chat server written in Go on Aptible, using the Gorilla web toolkit.  With additional authentication, authorization, and data persistence, this example app has the potential to become a HIPAA-compliant web chat product that might command millions of dollars in seed funding.

This guide assumes you have:

- An Aptible account
- An SSH key associated with your Aptible user account
- The [Aptible command line tool installed](/topics/cli/how-to-install-cli)

## 1. Get the Code

```
git clone https://github.com/wyc/aptible-go-websockets-chat
cd aptible-go-websockets-chat
```

## 2. Look Around

- `Dockerfile`: Sets up the image that will contain the app. It currently installs Go 1.3.2 and some command line utilities to compile and install the project and its dependencies.
`CMD` is ignored by Aptible but included for convention
- `Procfile`: Aptible reads this file to determine what to run. You can specify
multiple jobs, but this project did not.
- `*.go`: Application code.
- `*.html`: The served HTML template.

## 3. Provision Your App

Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example:

    aptible apps:create gorilla-quickstart

## 4. Add a Git Remote

Add a Git remote named "aptible":

    git remote add aptible git@beta.aptible.com:$ENVIRONMENT_HANDLE/$APP_HANDLE.git

For example:

    git remote add aptible git@beta.aptible.com:test-env/gorilla-quickstart.git

## 5. Deploy Your App

Push to the master branch of the Aptible Git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

    VHOST gorilla-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could access the chat server at gorilla-quickstart.on-aptible.com.

*Note:* Default VHOSTs are only automatically created for apps in development environments.

## 6. Additional steps for your apps

### Databases


By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the connection string as an environment variable to your app:

    aptible config:set DATABASE_URL=$CONNECTION_STRING

Then, use that environment variable to connect to the database:

```go
databaseURL := os.Getenv("DATABASE_URL")
conn, err := db.Connect(databaseURL)
// ...
```
To connect locally, see [the `aptible db:tunnel` command](/topics/cli/how-to-connect-to-database-from-outside/).

### App secrets

App secrets can be set as app environment variables via the Aptible CLI tool just as the DATABASE_URL was set.

    aptible config:set --app APP-HANDLE SENDGRID_USER=user SENDGRID_PASSWORD=hunter2

The environment variable should now be accessible by your app:

```go
twilio := gotwilio.NewTwilioClient(os.Getenv("SENDGRID_USER"), os.Getenv("SENDGRID_PASSWORD"))
```
