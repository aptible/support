On Aptible, you have many options for configuring logging.

If you filter PHI out of your logs, you can send them to any logging provider ([Papertrail is a popular choice](/topics/paas/how-to-set-up-papertrail).) If your logs may contain PHI, you should either use a HIPAA-compliant logging service that signs business associate agreements, or self-host an ELK logging stack in your Aptible account.

Setting up a self-hosted logging stack on Aptible is easy.

### Step 1: Set up an Elasticsearch instance

    aptible db:create $DB_HANDLE --type elasticsearch --account $ACCOUNT_HANDLE

You can also add `--size X` to the above command to provision an X GB database. The default size is 10 GB.

### Step 2: Set up a log drain

Next, under the "Logging" tab in your environment, add a log drain by selecting "Elasticsearch" as the type and selecting your database.

### Step 3: Set up a Kibana instance

Kibana is an open source, browser-based analytics and search dashboard for Elasticsearch. Follow the instructions in our [aptible/docker-kibana](https://github.com/aptible/docker-kibana) repo to deploy your own instance as an Aptible app.

That's it!
