When Aptible builds your app, it needs to run each of the commands in your Dockerfile. We leverage Docker's built-in caching support, but even with caching, some commands still take a long time to execute. For example, if you're using Bundler to manage dependencies, every time a single gem dependency changes, Docker's default caching mechanism would need to run `bundle install` from scratch, on an empty gemset.

To address this common case, Aptible provides an extension to Dockerfile, the `FROMCACHE` instruction. `FROMCACHE` works by caching the entire result of the current build and using it as the starting point for the next build.

To use this mechanism, add a `FROMCACHE` command to the beginning of your Dockerfile. Its argument is a cache key, allowing you to store multiple different cached images for each of your Aptible environments (one per cache key). As an example:

```dockerfile
FROMCACHE rails-2.1
FROM quay.io/aptible/ruby:ruby-2.1
```

If you use `FROMCACHE`, you'll also want to clear out your app directory in the Dockerfile before adding the latest version back in. (Otherwise, you may have leftover files from the last version, which may interfere with the current version.)

```dockerfile
### Remove ADDed app directory from old (cached) image
RUN rm -rf /opt/myapp

### Continue ADDing app directory, and building
ADD . /opt/myapp
WORKDIR /opt/myapp
RUN bundle install --without development test
```
