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

# Quickstart Guides
# Middleman Data Files: https://middlemanapp.com/advanced/data_files/
data.quickstart.each do |language_name, language_data|
  language_data[:name] = language_name
  language_url = "/quickstart/#{language_data.slug}"
  proxy "#{language_url}/index.html",
        'quickstart/category.html',
        locals: { language: language_data },
        ignore: true do
    @title = language_data.name + ' Quickstarts'
  end

  language_data.articles.each do |article|
    page "quickstart/#{article.url}.html", layout: 'quickstart.haml' do
      @framework = article.framework
      @language = language_data
      @title = @framework + ' Quickstart'
    end
  end
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

  # Zendesk will sometimes index slugged URLs by ID alone
  # e.g. /hc/en-us/categories/200178460-Getting-Started ->
  #      /hc/en-us/categories/200178460
  match = item['loc'].match(/(^.*[0-9]{9})/)
  redirect(match[1], item['url']) if match
end

helpers do
  def title_tag(opts = {})
    current_page = opts[:page]

    # Quickstart articles pass @title (see ~#L55)
    title = opts[:title]

    # Some pages also set it in front matter
    title ||= current_page.metadata[:locals][:title] ||
              current_page.data.header_title

    if title.nil? || title == 'Aptible Support'
      title = 'Aptible Support'
    else
      title = "#{title} | Aptible Support"
    end

    "<title>#{title}</title>"
  end

  def contact_href
    "#{base_url}/contact"
  end
end
