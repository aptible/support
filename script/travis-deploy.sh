#!/bin/bash
# Deploy to staging and production (but not on PRs)

if [ "$TRAVIS_BRANCH" == "master" ] &&
   [ "$TRAVIS_PULL_REQUEST" == "false" ] ; then
  bundle exec rake deploy:staging
  bundle exec rake deploy:production
fi
