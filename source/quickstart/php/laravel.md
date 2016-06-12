This guide will show you how to set up a PHP app using the Laravel framework and MySQL. This guide is for Laravel 4.0 or greater.

This guide assumes you have:

- An Aptible account
- An SSH key associated with your Aptible user account
- The [Aptible command line tool installed](/topics/cli/how-to-install-cli)

## 1. Provision Your App

Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example:

    aptible apps:create laravel-quickstart

## 2. Add a Dockerfile and a Procfile

A Dockerfile is a text file that contains the commands you would otherwise execute manually to build a Docker image. Aptible uses the resulting image to run your containers.

A Procfile explicitly declares what processes we should run for your app.

A few guidelines:

1. The files should be named "Procfile" and "Dockerfile": One word, initial capital letter, no extension.
2. Place both files in the root of your repository.
3. Be sure to commit them to version control.

Here is a sample Dockerfile for a Laravel app:

    # Dockerfile
    FROM tutum/apache-php
    ENV ALLOW_OVERRIDE true
    RUN apt-get update && apt-get install -yq git php5-mcrypt && rm -rf /var/lib/apt/lists/*

    RUN php5enmod mcrypt

    RUN rm -fr /app
    ADD . /app
    RUN rm /var/www/html
    RUN ln -s /app/public /var/www/html

    RUN composer install

    EXPOSE 80

Here is a sample Procfile for a Laravel app:

    # Procfile
    web: (touch /app/storage/logs/laravel.log && tail -F /app/storage/logs/laravel.log &) && /run.sh

## 3. Provision a Database

By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

In order to specify a MySQL database, use the `--type` flag:

    aptible db:create $DB_HANDLE --type mysql

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the database connection string to your app as an environment variable:

    aptible config:set --app laravel-quickstart DATABASE_URL=$CONNECTION_STRING

To connect locally, see [the `aptible db:tunnel` command](/topics/cli/how-to-connect-to-database-from-outside/).

## 4. Configure a Database Connection

Add the following PHP code to your `app/config/database.php` file to extract the MySQL connection info from the `DATABASE_URL` environment config you set in step 3.

    $url = parse_url(getenv('DATABASE_URL'));

    $host = $url["host"];
    $port = $url["port"];
    $username = $url["user"];
    $password = $url["pass"];
    $database = substr($url["path"], 1)

You can now use these variables in your MySQL config:

    'mysql' => array(
          'driver'    => 'mysql',
          'host'      => $host,
          'port'      => $port,
          'database'  => $database,
          'username'  => $username,
          'password'  => $password,
          'charset'   => 'utf8',
          'collation' => 'utf8_unicode_ci',
          'prefix'    => '',
          'options'   => array(
            PDO::MYSQL_ATTR_SSL_CIPHER => 'DHE-RSA-AES256-SHA'
          )
        ),

## 5. Configure a Git Remote

Add a Git remote named "aptible":

    git remote add aptible git@beta.aptible.com:$ENVIRONMENT_HANDLE/$APP_HANDLE.git
 
For example:

    git remote add aptible git@beta.aptible.com:test-env/laravel-quickstart.git

## 6. Deploy Your App

Push to the master branch of the Aptible Git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default SSL/TLS endpoint:

    VHOST laravel-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could visit laravel-quickstart.on-aptible.com to test out your app.

*Note:* Default SSL/TLS endpoints are only automatically created for apps in development environments.
