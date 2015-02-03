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

page '/documentation/*', layout: 'documentation'
page '/documentation*', layout: :documentation do
  @docs = data.documentation
end

data.support.each do |topic_name, topic|
  section_slug = topic_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  proxy "/support/#{section_slug}/index.html",  'support/category.html',
        locals: { topic: topic, topic_name: topic_name }
end

# Set up proxies for language category pages
# If the language has no or only one framework, skip category page and
# render language or framework document
page '/getting_started/*', layout: 'getting_started_guide.haml'
page '/support/*', layout: 'support.haml'

data.getting_started.each do |language_name, language_info|
  section_slug = language_name.downcase
  proxy_url = "/getting_started/#{section_slug}/index.html"
  proxy_to = 'getting_started/category.html'

  if language_info.articles && language_info.articles.count > 1
    proxy proxy_url, proxy_to,
        locals: { language_name: language_name,
                  language_info: language_info,
                  data: { header_title: 'Ruby!'} }
  end
end

configure :build do
  # Exclude all Bower components except image assets
  ignore /bower_components(?!.*\/images\/)/

  # Don't build pages only used as proxies
  ignore 'getting_started/category*'
  ignore 'support/category*'

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