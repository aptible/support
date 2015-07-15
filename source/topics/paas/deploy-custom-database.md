Yes, you can deploy a custom database on Aptible, provided that it's packaged in a Docker image conforming to the following specification:

* Any files or directories that need to persist should be defined as `VOLUME`s in the Dockerfile. Aside from the data stored in the database, this may include database configuration files, user lists, etc.

* The image should have an `ENTRYPOINT` in its Dockerfile.

* The database will be initialized by running the image with one argument, `--initialize`. When the entrypoint script is invoked in this way, it should create the database and, optionally, a user account. The initialization script runs in an ephemeral container, so it's important to use a volumed location for any configuration which needs to persist.

    The following environment variables will be supplied:

    * `USERNAME` database access should be granted to a user with this username
    * `PASSPHRASE` the created user (if applicable) should have this passphrase
    * `DATABASE` the name of the database to create
    * `SSL_CERTIFICATE` a PEM-encoded SSL certificate
    * `SSL_KEY` a PEM-encoded SSL key

    These environment variables may not all be relevant. For example, redis doesn't have users or named databases, so a redis image would only use `$PASSPHRASE`. If the database needs an SSL key pair to enable secure connections, it should use the key pair defined by `$SSL_CERTIFICATE` and `$SSL_KEY`.

* The database service will be started by running the image with no arguments. It is important that the database process stay in the foreground (i.e. not daemonize) so that Docker doesn't think the container has stopped running.

Some examples of Docker images conforming to this specification:

* [aptible/docker-redis](https://github.com/aptible/docker-redis)
* [aptible/docker-postgresql](https://github.com/aptible/docker-postgresql)
* [aptible/docker-mysql](https://github.com/aptible/docker-mysql)

If you have any questions about developing a custom database image, or if you're ready to deploy one that you've created, please [contact support](https://support.aptible.com/contact).

---

When developing a custom database image to be used on Aptible, the following approach may be used to confirm that the database is working to spec. (We assume that the database image is named `mydb`.)

```bash
docker create --name mydata mydb
docker run --volumes-from mydata -e USERNAME=user -e PASSPHRASE=pass -e DB=db mydb --initialize
docker run --volumes-from mydata -P mydb
```

If you can connect to the database `db` on the final container's exposed port, with username and passphrase `user` and `pass` respectively, then initialization has been completed successfully.
