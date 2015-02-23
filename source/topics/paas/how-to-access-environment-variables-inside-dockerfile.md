By design (for better or worse), Docker doesn't allow setting any environment variables during the Docker build process, only afterwards on running containers instantiated from the built images. The idea is that images should be fully portable and not tied to any specific environment. This means that your Aptible `ENV` variables, set via `aptible config:set`, are not available to commands executed during your Dockerfile build.

Our workaround for this is to allow use of a `.aptible.yml` file, in which a set of "before\_release" commands may be specified. These are run once, regardless of how many containers you've scaled your app services to, and have the same environment as your app. If any of the "before\_release" commands fail, the deploy will fail, and the previous release will remain running.

An example `.aptible.yml` file (note the period at the beginning of the filename) is:

```yaml
before_release:
- bundle exec rake db:migrate
```

In this example, database migrations will occur with the current app configuration — referencing the correct production database — immediately before the production app is started.
