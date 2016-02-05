Currently, Aptible supports the following databases:

* PostgreSQL
* Redis
* MongoDB
* MySQL
* CouchDB
* Elasticsearch

Databases can be provisioned either from the Dashboard or Aptible CLI.  To provision a database from Dashboard, simply click on the 'Databases' tab on the top navigation and then click the 'Create Database' button.

To provision a database using Aptible CLI, use the `aptible db:create` command:

```
aptible db:create --type <DATABASE_TYPE> --size <SIZE_IN_GB> <DATABASE_HANDLE>
```

If you'd like to run another database on top of Aptible, please [contact support](https://aptible.zendesk.com/hc/en-us/requests/new).
