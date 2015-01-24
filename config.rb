require 'bootstrap-sass'
require 'font-awesome-sass'
require 'fog'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'partials'

activate :syntax, line_numbers: true
activate :directory_indexes

# Documentation
page '/documentation/*', layout: 'documentation.haml'

# Topics (Support)
data.topics.each do |title, topic|
  proxy "/topics/#{topic.slug}/index.html",
        'topics/category.html',
        locals: { topic: topic, title: title }
end

# Quickstart (Getting Started)
# If the language has no or only one framework, skip category page and
# render language or framework document
page '/quickstart/*', layout: 'quickstart.haml'
data.quickstart.each do |title, language|
  proxy_url = "/quickstart/#{language.slug}/index.html"
  proxy_to = 'quickstart/category.html'

  next unless (language.articles || []).count > 1
  proxy proxy_url, proxy_to, locals: {
    title: title,
    language: language
  }
end

configure :build do
  # Exclude all Bower components except image assets
  ignore /bower_components(?!.*\/images\/)/

  # Don't build pages only used as proxies
  ignore 'quickstart/category*'
  ignore 'topics/category*'

  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

activate :s3_redirect do |config|
  config.bucket = ENV['S3_BUCKET'] || 'support.aptible-staging.com'
  config.region = 'us-east-1'
  config.after_build = false
end

data.redirects.each do |item|
  redirect item['loc'], item['url']
end
