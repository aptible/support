---
title: Express + Mongoose + MongoDB Quickstart
sub_title: Deploy your Express + Mongoose + MongoDB app on Aptible in about 5 minutes
---


This guide will show you how to set up a Node.js app using the Express framework and the Mongoose ODM for MongoDB.

This guide assumes you have:
- An Aptible account,
- An SSH key associated with your Aptible user account, and
- The Aptible command line tool installed

## 1. Provision Your App
Tell the Aptible API that you want to provision an application. Until you push code and trigger a build, Aptible uses this as a placeholder.

Use the `apps:create` command: `aptible apps:create $APP_HANDLE`

For example:
```
aptible apps:create express-quickstart
```

## 2. Add a Dockerfile and a Procfile
Aptible uses Docker to build your app's runtime environment. A Dockerfile is a list of commands used to build that image. A Procfile is used to explicitly declare what processes Aptible should run for your app.

A few guidelines:
1. Name each file one word, capital "D"/P", no extension: "Dockerfile" and "Procfile".
2. Place both files in the root of your repository.
3. Be sure to commit both files to version control.

Here is a sample Dockerfile for a Node.js app:

```Dockerfile
FROM quay.io/aptible/nodejs:v0.10.x

ADD . /opt/nodejs
WORKDIR /opt/nodejs
RUN npm install

ENV PORT 3000
EXPOSE 3000

CMD node server.js -p $PORT
```

Here is a sample Procfile for a Node.js app:

```bash
web: node server.js -p $PORT
```

## 3. Provision a Database
By default, `aptible db:create $DB_HANDLE` will provision a 10GB PostgreSQL database.

For a Mongodb database, we will specify the `--type` option:

```bash
aptible db:create $DB_HANDLE --type mongodb
```

`aptible db:create` will return a connection string on success. The host value is mapped to a private subnet within your stack and cannot be used to connect from the outside Internet. Your containerized app can connect, however.

Add the connection string as an environmental variable to your app:

```bash
aptible config:add DATABASE_URL=$CONNECTION_STRING --app $APP_HANDLE
```

## 4. Connect the Database Using Mongoose
The example script below starts a simple Express app, connects to a Mongodb database using Mongoose, saves a simple document, and retreives the object when the index route is requested.

```json
{
  "_filename": "package.json",
  "name": "express-quickstart",
  "version": "0.0.1",
  "dependencies": {
    "express": "4.10.7",
    "mongoose": "3.8.21"
  }
}
```

```javascript
// server.js
var express = require('express');
var mongoose = require('mongoose');

// start Express
var app = express();
var port = process.env.PORT;
if (!module.parent) {
  app.listen(parseInt(port));
  console.log('Express started on port ' + port);
};

// connect to Mongodb
mongoose.connect(process.env.DATABASE_URL);
var db = mongoose.connection;

// create a new model
var Animal = mongoose.model('Animal', {
  name: String
});

// create a document and save it to the database
var octopus = new Animal({
  name: 'Octotron ' + Math.floor((Math.random() * 1000) +1 )
});

db.once('open', function(callback) {
  octopus.save(function(err) {
    if (err) {
      console.log('Error saving to db.');
    };
    console.log(octopus.name + ' saved to db.');
  });
});

// retrieve the document and send a response
app.get('/', function(req, res) {
  var query = Animal.where( { name: octopus.name });
  query.findOne(function (err, animal) {
    if (err) return console.log(err);
    if (animal) {
      res.send('Found ' + animal.name + ' in the database.');
    }
  });
});
```

## 5. Configure a Git Remote
Add a Git remote named "aptible":

```bash
git remote add aptible git@beta.aptible.com:$APP_HANDLE.git
```

For example:

```bash
git remote add aptible git@beta.aptible.com:express-quickstart.git
```

## 6. Deploy Your App

Push to the master branch of the Aptible git remote:

```bash
git push aptible master
```

If your app deploys successfully, a message will appear near the end of the remote output with a default VHOST:

```bash
VHOST express-quickstart.on-aptible.com provisioned.
```

In this example, once the ELB provisions you could visit express-quickstart.on-aptible.com to test out your app.
