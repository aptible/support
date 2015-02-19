---
title: Ruby on Rails Quickstart
subtitle: Deploy your Ruby on Rails app to Aptible in about 5 minutes
---

This guide will show you how to set up a Ruby app using the Rails framework and ActiveRecord + PostgreSQL. This guide is for Rails 4.0 or greater. If you are on an older version of Rails, your app will need [additional configuration](http://edgeguides.rubyonrails.org/configuring.html#configuring-a-database) to connect to a database.

This guide assumes you have:

- An Aptible account,
- An SSH key associated with your Aptible user account, and
- The Aptible command line tool installed

## 1. Provision Your App

Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example:

    aptible apps:create rails-quickstart

## 2. Add a Git Remote

Add a Git remote named "aptible":

    git remote add aptible git@beta.aptible.com:$APP_HANDLE.git

For example:

    git remote add aptible git@beta.aptible.com:rails-quickstart.git

## 3. Add a Procfile

A Procfile explicitly declares what processes we should run for your app.

A few guidelines:

1. The file should be named "Procfile": One word, capital "P", no extension.
2. Place the Procfile in the root of your repository.
3. Be sure to commit it to version control.

Here is a sample Procfile for a Ruby on Rails app:

    web: bundle exec rails s -p $PORT

> Note: Aptible uses Docker to build and run your app. If you do not include a Dockerfile in your repository, Aptible will attempt to build your app with the [tutum/buildstep](https://registry.hub.docker.com/u/tutum/buildstep/) image.

## 4. Provision and Connect a Database

By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the connection string as an environment variable to your app:

    aptible config:add DATABASE_URL=$CONNECTION_STRING

## 5. Deploy Your App
Push to the master branch of the Aptible git remote:

    git push aptible master

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

    VHOST rails-quickstart.on-aptible.com provisioned.

In this example, once the ELB provisions you could visit rails-quickstart.on-aptible.com to test out your app.
