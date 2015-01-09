address: support.aptible.com/quickstart/ruby/rails
default for /quickstart/ruby

### Ruby on Rails Quickstart
This guide will show you how to set up a Ruby app using the Rails framework and ActiveRecord + PostgreSQL. This guide is for Rails 4.0 or greater. If you are on an older version of Rails, your app will need [additional configuration](http://edgeguides.rubyonrails.org/configuring.html#configuring-a-database) to connect to a database.

This guide assumes you have:   
- An Aptible account,  
- An SSH key associated with your Aptible user account, and  
- The Aptible command line tool installed

#### 1. Provision Your App  
Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example: 
```
aptible apps:create rails-quickstart
```

#### 2. Add a Dockerfile and a Procfile
Aptible uses Docker to build your app's runtime environment. A Dockerfile is a list of commands used to build that image. A Procfile is used to explicitly declare what processes Aptible should run for your app.

A few guidelines:  
1. Name each file one word, capital "D"/P", no extension: "Dockerfile" and "Procfile".  
2. Place both files in the root of your repository.  
3. Be sure to commit both files to version control.  

Here is a sample Dockerfile for a Ruby on Rails app:
```Dockerfile
FROM quay.io/aptible/ruby:ruby-2.0.0

RUN apt-get update && apt-get -y install libpq-dev nodejs
 
ADD . /opt/rails
WORKDIR /opt/rails
RUN bundle install --without development test
RUN bundle exec rake assets:precompile
 
ENV PORT 3000
EXPOSE 3000
 
CMD bundle exec rails s -p $PORT
```

Here is a sample Procfile for a Ruby on Rails app:
```
web: bundle exec rails s -p $PORT
```

#### 3. Provision and Connect a Database  
By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the connection string as an environmental variable to your app:
```
aptible config:add DATABASE_URL=$CONNECTION_STRING --app $APP_HANDLE
```

#### 4. Configure a Git Remote
Add a Git remote named "aptible":
```
git remote add aptible git@beta.aptible.com:$APP_HANDLE.git
```

For example:
``` 
git remote add aptible git@beta.aptible.com:rails-quickstart.git
```

#### 5. Deploy Your App
Push to the master branch of the Aptible git remote:
```
git push aptible master
```
If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:
```
VHOST rails-quickstart.on-aptible.com provisioned.
```

In this example, once the ELB provisions you could visit rails-quickstart.on-aptible.com to test out your app.
