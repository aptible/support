# ![Aptible](http://aptible-media-assets-manual.s3.amazonaws.com/tiny-github-icon.png) Aptible Support

_Deprecated: For current documentation, visit https://www.aptible.com/documentation; for documentation source, see [aptible/docs](https://github.com/aptible/docs). We're keeping this repo around for historical support requests opened as GitHub issues. If you have a support request, please visit http://contact.aptible.com or check for an answer to your question on https://community.aptible.com._

[![Build Status](https://travis-ci.org/aptible/support.png?branch=master)](https://travis-ci.org/aptible/support)
[![Roadmap](https://badge.waffle.io/aptible/support.svg?label=ready&title=roadmap)](http://waffle.io/aptible/support)

Aptible's Support and Documentation Site

## Running Locally

First, clone the repo:

    git clone https://github.com/aptible/support.git
    cd support/

Then, install necessary dependencies:

    bower install
    bundle install

Finally, start the server. You can access it at http://localhost:4567/

    bundle exec middleman server

## Deploying

First, some prerequisites:

* [AWS CLI](http://aws.amazon.com/cli/), installed locally
* A valid `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in your environment

In [production](https://support.aptible.com) and [staging](https://support.aptible-staging.com), the support site is deployed as an S3 website (fronted by CloudFront).

To manually deploy to production, using [Omnivault](https://github.com/aptible/omnivault):

    eval $(aws-creds env default) && bundle exec rake deploy:production

Staging:

    eval $(aws-creds env default) && bundle exec rake deploy:staging

An arbitrary S3 bucket:

    eval $(aws-creds env default) && bundle exec rake deploy[bucket]

### Continuous Deployment

Travis CI deploys to both staging and production on every successful merge to master. This requires the encrypted AWS credentials for an authorized user to be stored in the .travis.yml configuration file.

To update these credentials at any time, run:

    travis encrypt -r aptible/support --add env AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...

## Contributing

If you run into an issue that needs documentation, feel free to submit a pull request or open an issue. We send t-shirts and swag to contributors.

## Contributors

* Skylar Anderson ([@sandersonet](https://github.com/sandersonet))
* Chas Ballew ([@chasballew](https://github.com/chasballew))
* Frank Macreery ([@fancyremarker](https://github.com/fancyremarker))
* Wayne Chang ([@wyc](https://github.com/wyc))

## Copyright

Copyright (c) 2016 [Aptible](https://www.aptible.com). All rights reserved.

[<img src="https://secure.gravatar.com/avatar/566f0093e212d9b808c0cece8a32480e?s=60" style="border-radius: 50%;" alt="@gib" />](https://github.com/gib)

