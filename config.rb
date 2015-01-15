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

data.support.each do |section, entries|
  section_slug = section.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  proxy "/support/#{section_slug}/index.html",  'support/category.html',
        locals: { articles: entries, category: section }
end

# Set up proxies for language category pages
# If the language has no or only one framework, skip category page and
# render language or framework document
page '/getting_started/*', layout: 'getting_started_guide.haml'
data.getting_started.each do |language_name, language_info|
  section_slug = language_name.downcase
  proxy_url = "/getting_started/#{section_slug}/index.html"
  proxy_to = 'getting_started/category.html'

  if language_info.frameworks && language_info.frameworks.count > 1
    proxy proxy_url, proxy_to,
        locals: { language_name: language_name,
                  language_info: language_info,
                  data: { header_title: 'Ruby!'} }
  end
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end
