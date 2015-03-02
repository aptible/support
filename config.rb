require 'bootstrap-sass'
require 'font-awesome-sass'
require 'fog'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'partials'

# (Semi-) secrets
set :swiftype_key, 'dsMEc1fYviE2ShXAjYMW'
set :swiftype_engine, 'axuhZ5Lt1ZUziN-DqxnR'
set :base_url, ENV['BASE_URL'] || 'https://support.aptible.com'

activate :syntax, line_numbers: true
activate :directory_indexes

# Documentation
# TODO: Enable documentation section
# page '/documentation/*', layout: 'documentation.haml'

# Topics (Support)
data.topics.each do |title, category|
  category_url = "/topics/#{category.slug}"
  page "#{category_url}/index.html", layout: 'topics.haml'
  proxy "#{category_url}/index.html",
        'topics/category.html',
        locals: { category: category, title: title },
        ignore: true

  category.articles.each do |article|
    page "topics/#{article.url}.html", layout: 'topics.haml' do
      @category_url = category_url
      @category_title = title
      @title = article.title
    end
  end
end

# Quickstart (Getting Started)
# If the language has no or only one framework, skip category page and
# render language or framework document
page '/quickstart/*', layout: 'quickstart.haml'
data.quickstart.each do |title, language|
  next unless (language.articles || []).count > 1

  language_url = "/quickstart/#{language.slug}"
  proxy "#{language_url}/index.html",
        'quickstart/category.html',
        locals: { title: title, language: language },
        ignore: true
end

configure :build do
  # Exclude all Bower components except image assets
  ignore %r{bower_components(?!.*/images/)}

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

helpers do
  def title_tag(opts = {})
    current_page = opts[:page]
    title = opts[:title]
    category = opts[:category] || 'Aptible Support'

    title = title || current_page.metadata[:locals][:title] ||
            current_page.data.title
    title = title.nil? ? 'Aptible Support' : "#{title} | #{category}"

    "<title>#{title}</title>"
  end

  def contact_href
    "#{base_url}/contact"
  end
end
