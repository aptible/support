If you are connecting to a MongoDB 3.x (the default) database on Aptible,
either through your app or running `aptible db:tunnel`, you may hit an
error looking like this:

    MongoDB shell version: 3.2.1
    connecting to: 172.17.0.2:27017/db
    2016-02-08T10:43:40.421+0000 E QUERY    [thread1] Error: network error while attempting to run command 'isMaster' on host '172.17.0.2:27017'  :
    connect@src/mongo/shell/mongo.js:226:14
    @(connect):1:6

    exception: connect failed

This error is usually caused by attempting to connect without SSL to a MongoDB
server that enforces it, which is the default on Aptible. To solve the issue,
connect to your MongoDB server over SSL:

```
mongo --ssl --sslAllowInvalidCertificates  -u aptible -p "$PASSWORD" --host 127.0.0.1 --port $PORT
```


Your Mongo client might not recognize these options unless it is compiled with SSL. If you get an error indicating that SSL isn't supported, re-install the MongoDB client with SSL support. 

If you are unable to resolve the issue, contact support.
