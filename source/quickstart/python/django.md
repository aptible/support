This guide will show you how to set up a Python app using the Django framework, Gunicorn, and PostgreSQL.

This guide assumes you have:

- An Aptible account
- An SSH key associated with your Aptible user account
- The Aptible command line tool installed

## 1. Provision Your App

Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example:


    aptible apps:create django-quickstart

## 2. Add a Git Remote

Add a Git remote named "aptible":

    git remote add aptible git@beta.aptible.com:$APP_HANDLE.git

For example:

    git remote add aptible git@beta.aptible.com:django-quickstart.git

## 3. Add a Procfile

A Procfile explicitly declares what processes we should run for your app.

A few guidelines:

1. The file should be named "Procfile": One word, capital "P", no extension.
2. Place the Procfile in the root of your repository.
3. Be sure to commit it to version control.

Here is a sample Procfile for a Django app, logging to stderr:

    web: gunicorn myproject.wsgi --log-file - --bind="0.0.0.0:$PORT"

> Note: Aptible uses Docker to build and run your app. If you do not include a Dockerfile in your repository, Aptible will attempt to build your app with the [tutum/buildstep](https://registry.hub.docker.com/u/tutum/buildstep/) image.

## 4. Provision and Connect a Database

By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the connection string as an environment variable to your app:

    aptible config:add DATABASE_URL=$CONNECTION_STRING

To use the DATABASE_URL variable in your Django app, install the [dj-database-url package](https://warehouse.python.org/project/dj-database-url/), then in `settings.py`:

```python
DATABASES = {'default': dj_database_url.config()}
```

## 5. Deploy Your App

Push to the master branch of the Aptible git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

    VHOST django-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could visit django-quickstart.on-aptible.com to test out your app.
