address: support.aptible.com/quickstart/scala/play

### Play Quickstart
This guide will show you how to set up a Scala app using the Play framework and PostgreSQL.

This guide assumes you have:   
- An Aptible account,  
- An SSH key associated with your Aptible user account, and  
- The Aptible command line tool installed

#### 1. Provision Your App  
Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example: 
```
aptible apps:create play-example
```

#### 2. Configure a Git Remote
Add a Git remote named "aptible":
```
git remote add aptible git@beta.aptible.com:$APP_HANDLE.git
```

For example:
```
git remote add aptible git@beta.aptible.com:play-example.git
```

#### 3. Add a Dockerfile and a Procfile
Aptible uses Docker to build your app's runtime environment. A Dockerfile is a list of commands used to build that image. A Procfile is then used to explicitly declare what processes Aptible should run for your app.

A few guidelines:  
1. Name each file one word, capital "D"/"P", no extension: "Dockerfile" and "Procfile".  
2. Place them in the root of your repository.  
3. Be sure to commit both files to version control.  

Here is a sample Dockerfile for a Scala app using the Play framework:
```
[example Dockerfile]
```

Here is a sample Procfile:
```
web: target/universal/stage/bin/playexample \
     -Dhttp.port=$PORT \
     -DapplyEvolutions.default=true \
     -Ddb.default.driver=org.postgresql.Driver \
     -Ddb.default.url=$DATABASE_URL
```
Alternatively, you can omit the runtime database configuration options and instead use your `conf/application.conf` file.

#### 4. Provision and Connect a Database
By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the connection string as an environmental variable to your app:
```
aptible config:add DATABASE_URL=$CONNECTION_STRING
```

#### 5. Deploy Your App
Push to the master branch of the Aptible git remote:
```
git push aptible master
```
If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:
```
VHOST play-example.on-aptible.com provisioned.
```

In this example, once the ELB provisions you could visit play-example.on-aptible.com to test out your app.
