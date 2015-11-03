This guide will show you how to set up a Python app using the Flask framework, Gunicorn, SQLAlchemy, and PostgreSQL.

This guide assumes you have:

- An Aptible account
- An SSH key associated with your Aptible user account
- The [Aptible command line tool installed](/topics/cli/how-to-install-cli)

## 1. Provision Your App

Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example:

    aptible apps:create flask-quickstart

## 2. Add a Git Remote

Add a Git remote named "aptible":

    git remote add aptible git@beta.aptible.com:$APP_HANDLE.git

For example:

    git remote add aptible git@beta.aptible.com:flask-quickstart.git


## 3. Add a Dockerfile and a Procfile

A Dockerfile is a text file that contains the commands you would otherwise execute manually to build a Docker image. Aptible uses the resulting image to run your containers.

A Procfile explicitly declares what processes we should run for your app.

A few guidelines:

1. The files should be named "Procfile" and "Dockerfile": One word, initial capital letter, no extension.
2. Place both files in the root of your repository.
3. Be sure to commit them to version control.

Here is a sample Dockerfile for a conventional Flask app:

    # Dockerfile
    FROM quay.io/aptible/ubuntu:14.04

    # Basic dependencies
    RUN apt-install build-essential python-dev python-setuptools
    RUN apt-install libxml2-dev libxslt1-dev python-dev

    # PostgreSQL dev headers and client (uncomment if you use PostgreSQL)
    # RUN apt-install libpq-dev postgresql-client-9.3 postgresql-contrib-9.3

    # MySQL dev headers (uncomment if you use MySQL)
    # RUN apt-install libmysqlclient-dev

    RUN easy_install pip

    # Add requirements.txt ONLY, then run pip install, so that Docker cache won't
    # bust when changes are made to other repo files
    ADD requirements.txt /app/
    WORKDIR /app
    RUN pip install -r requirements.txt

    # Add repo contents to image
    ADD . /app/

    ENV PORT 3000
    EXPOSE 3000

Here is a sample Procfile for a Flask app:

    # Procfile
    web: gunicorn app:app --bind="0.0.0.0:$PORT"

## 4. Provision and Connect a Database

By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the database connection string to your app as an environment variable:

    aptible config:set DATABASE_URL=$CONNECTION_STRING

In `config.py`:

    SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URL']

To connect locally, see [the `aptible db:tunnel` command](/topics/cli/how-to-connect-to-database-from-outside/).

## 5. Deploy Your App
Push to the master branch of the Aptible Git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

    VHOST flask-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could visit flask-quickstart.on-aptible.com to test out your app.
