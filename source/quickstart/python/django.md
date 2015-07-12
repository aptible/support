This guide will show you how to set up a Python app using the Django framework, Gunicorn, and PostgreSQL.

This guide assumes you have:

- An Aptible account
- An SSH key associated with your Aptible user account
- The [Aptible command line tool installed](/topics/cli/how-to-install-cli)

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

## 3. Add a Dockerfile and a Procfile

A Dockerfile is a text file that contains the commands you would otherwise execute manually to build a Docker image. Aptible uses the resulting image to run your containers.

A Procfile explicitly declares what processes we should run for your app.

A few guidelines:

1. The files should be named "Procfile" and "Dockerfile": One word, initial capital letter, no extension.
2. Place both files in the root of your repository.
3. Be sure to commit them to version control.

Here is a sample Dockerfile that uses Aptible's `autobuild` image:

    # Dockerfile
    FROM quay.io/aptible/autobuild

Here is a sample Procfile for a Django app, logging to stderr:

    # Procfile
    web: gunicorn myproject.wsgi --log-file - --bind="0.0.0.0:$PORT"

## 4. Provision and Connect a Database

By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the database connection string to your app as an environment variable:

    aptible config:add DATABASE_URL=$CONNECTION_STRING

To use the DATABASE_URL variable in your Django app, install the [dj-database-url package](https://warehouse.python.org/project/dj-database-url/), then in `settings.py`:

    DATABASES = {'default': dj_database_url.config()}

## 5. Deploy Your App

Push to the master branch of the Aptible git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

    VHOST django-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could visit django-quickstart.on-aptible.com to test out your app.
