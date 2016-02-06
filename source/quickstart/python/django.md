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

    git remote add aptible git@beta.aptible.com:$ENVIRONMENT_HANDLE/$APP_HANDLE.git

For example:

    git remote add aptible git@beta.aptible.com:test-env/django-quickstart.git

## 3. Add a Dockerfile and a Procfile

A Dockerfile is a text file that contains the commands you would otherwise execute manually to build a Docker image. Aptible uses the resulting image to run your containers.

A Procfile explicitly declares what processes we should run for your app.

A few guidelines:

1. The files should be named "Procfile" and "Dockerfile": One word, initial capital letter, no extension.
2. Place both files in the root of your repository.
3. Be sure to commit them to version control.

Here is a sample Dockerfile for a conventional Django app, running Python 2.7.6:

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

Here's an alternate Dockerfile, specifically for Python 3. (Thanks [JP Bader](https://github.com/lordB8r) for testing and contributing this!)

    # Dockerfile specifically for python3
    FROM python:3-wheezy
    You can do python version this way (uncomment to configure):
    RUN apt-install python3-minimal
    RUN ln -s python3 /usr/bin/python

    # See http://wiki.postgresql.org/wiki/Apt
    ENV PG_VERSION=9.3 \
        PG_USER=postgres \
        PG_HOME=/var/lib/postgresql \
        PG_RUNDIR=/run/postgresql \
        PG_LOGDIR=/var/log/postgresql

    ENV PG_CONFDIR="/etc/postgresql/${PG_VERSION}/main" \
        PG_BINDIR="/usr/lib/postgresql/${PG_VERSION}/bin" \
        PG_DATADIR="${PG_HOME}/${PG_VERSION}/main"

    RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
        && echo 'deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} \
        && rm -rf ${PG_HOME} \
        && rm -rf /var/lib/apt/lists/*

    # MySQL dev headers (uncomment if you use MySQL)
    # RUN apt-install libmysqlclient-dev

    # Add requirements.txt ONLY, then run pip install, so that Docker cache won't
    # bust when changes are made to other repo files
    ADD requirements.txt /app/
    WORKDIR /app
    RUN pip install -r requirements.txt

    # Add repo contents to image
    ADD . /app/

    ENV PORT 8000
    EXPOSE 8000

    # Potentially have to set work directory for this to work
    # WORKDIR /app/YOUR_APP


Here is a sample Procfile for a Django app, logging to stderr:

    # Procfile
    web: gunicorn myproject.wsgi --log-file - --bind="0.0.0.0:$PORT"

## 4. Provision and Connect a Database

By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the database connection string to your app as an environment variable:

    aptible config:set DATABASE_URL=$CONNECTION_STRING

To use the DATABASE_URL variable in your Django app, install the [dj-database-url package](https://warehouse.python.org/project/dj-database-url/), then in `settings.py`:

    import dj_database_url
    DATABASES = {'default': dj_database_url.config()}

To connect locally, see [the `aptible db:tunnel` command](/topics/cli/how-to-connect-to-database-from-outside/).

## 5. Deploy Your App

Ensure there is a `requirements.txt` file at the root of your project so Aptible knows this is a Python app:

    # sample requirements.txt
    Django==1.8.4
    dj-database-url
    psycopg2
    gunicorn

Push to the master branch of the Aptible Git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

    VHOST django-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could visit django-quickstart.on-aptible.com to test out your app.

Be sure to add this VHOST to your [`ALLOWED_HOSTS`](https://docs.djangoproject.com/en/1.8/ref/settings/#allowed-hosts) in your settings module:

```python
ALLOWED_HOSTS = ['django-quickstart.on-aptible.com']
```

*Note:* Default VHOSTs are only automatically created for apps in development environments.

Finally, you'll likely want to [SSH into your app](https://support.aptible.com/topics/cli/how-to-ssh-into-app/) and migrate the database:

    aptible ssh --app $APP_HANDLE
    python manage.py migrate

## 6. Set Up Static Files

By default, Django does not support serving static files in production. However, you can use [WhiteNoise](https://warehouse.python.org/project/whitenoise/) for best-practice serving of static assets in production.

### Install Whitenoise:

```bash
pip install whitenoise
pip freeze > requirements.txt
```

### Update WSGI module

```python
# myproject/wsgi.py
import os

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "myproject.settings")

from django.core.wsgi import get_wsgi_application
from whitenoise.django import DjangoWhiteNoise

application = DjangoWhiteNoise(get_wsgi_application())
```

### Update Django Settings

```python
# myproject/settings.py

# Tell Django where to put compiled static assets when running `collectstatic`
STATIC_ROOT = 'staticfiles'

STATICFILES_STORAGE = 'whitenoise.django.GzipManifestStaticFilesStorage'
```
