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
set :swiftype_key, ENV['SWIFTYPE_KEY'] || 'dsMEc1fYviE2ShXAjYMW'
set :swiftype_engine, ENV['SWIFTYPE_ENGINE'] || 'axuhZ5Lt1ZUziN-DqxnR'
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
        ignore: true do
    @description = "Aptible support questions about #{title}"
  end

  category.articles.each do |article|
    page "topics/#{article.url}.html", layout: 'topics.haml' do
      @category_url = category_url
      @category_title = title
      @title = article.title
      @description = 'Aptible support guides and answers'
      @og_type = 'article'
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
    @title = "#{language_data.name} Quickstart Guides"
    @description = "Guides for getting started with #{language_data.name} "\
                   'on Aptible'
  end

  language_data.articles.each do |article|
    page "quickstart/#{article.url}.html", layout: 'quickstart.haml' do
      @framework = article.framework
      @language = language_data
      @title = "#{@framework} Quickstart"
      @description = 'Step-by-step instructions for getting started '\
                     "with #{@framework} on Aptible"
      @og_type = 'article'
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
  def sanitize(str)
    str.gsub(/"|'/, '')
  end

  def title_tags(opts = {})
    current_page = opts[:page]

    # Article pages pass @title as an option
    title = opts[:title]

    # Some pages also set it in front matter
    title ||= current_page.metadata[:locals][:title] ||
              current_page.data.header_title

    # Some pages just have a default title, which we don't want to repeat
    if title.nil? || title == 'Aptible Support'
      swiftype_title = title = 'Aptible Support'
    else
      # Use a clean title for Swifttype
      swiftype_title = title
      title = "#{title} | Aptible Support"
    end

    title = sanitize(title)
    swiftype_title = sanitize(swiftype_title)

    "<title>#{title}</title> \n" \
    "<meta property=\"og:title\" content=\"#{title}\" > \n" \
    "<meta class=\"swiftype\" name=\"title\" " \
    "data-type=\"string\" content=\"#{swiftype_title}\" >"
  end

  def meta_tags(opts = {})
    description = opts[:description]
    og_type = opts[:og_type]

    description ||= current_page.data.header_subtitle

    url = "#{base_url}#{current_page.url}"

    og_type = og_type.nil? ? 'website' : 'article'

    description = sanitize(description)

    "<meta property=\"og:description\" content=\"#{description}\" >\n" \
    "<meta property=\"og:url\" content=\"#{url}\" >\n"\
    "<meta property=\"og:type\" content=\"#{og_type}\" >"
  end

  def contact_href
    "#{base_url}/contact"
  end
end
