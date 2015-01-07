![Aptible](http://aptible-media-assets-manual.s3.amazonaws.com/web-horizontal-350.png)

# aptible-sass

Common assets for Aptible's web clients.

Requires: 

- SASS
- Bootstrap 3
- CoffeeScript
- jQuery
- ~~Underscore.js~~ (vendored in as of 0.3.0)

The layouts require:

- HAML
- Our [aptible-rails](https://github.com/aptible/aptible-rails) route helpers

## Install

1. Add a `.bowerrc` file to your project. Specify where Bower should install the files with `{ "directory": "your/path" }`
2. `bower install aptible-sass`
3. `.gitignore` the Bower install directory.
4. Add the aptible-sass resources to your asset manifests. If you use Sprockets, add the aptible-sass images and scripts directories to `config.asset.paths` in `application.rb`. In addition, add the Javascripts to your Sprockets manifest. For SASS, `@import` the mixins and a layout file before Bootstrap. Include the main aptible-sass manifest after Bootstrap.

Example project `application.scss`:
```CSS
@import "../../../vendor/assets/aptible-sass/dist/styles/aptible_fixed";
@import "font-awesome";
@import "policy_manuals";
```

Example project `application.rb`:
```ruby
require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env)
module Policy
  class Application < Rails::Application
    # Sprockets needs this, in addition to the manifest
    config.assets.paths << Rails.root.join(
      'vendor',
      'aptible-sass',
      'dist',
      'scripts'
    )
    config.assets.paths << Rails.root.join(
      'vendor',
      'assets',
      'aptible-sass',
      'dist',
      'images'
    )
  end
end
```
Example project `application.js`:
```javascript
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require bootstrap
//= require policy
//= require_directory ../../../vendor/assets/aptible-sass/dist/scripts
//= require_tree .
```

## Develop
1. For local development of both aptible-sass and a project that depends on it, `bower link` in this directory, then `bower link aptible-sass` in your project.
2. Render partials with references to the full path.

<small>&copy; 2014 Aptible</small>

[<img src="https://s.gravatar.com/avatar/9b58236204e844e3181e43e05ddb0809?s=60" style="border-radius: 50%;" alt="@sandersonet" />](https://github.com/sandersonet)