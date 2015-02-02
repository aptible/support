require 'middleman'
require 'middleman-syntax'
require 'rspec'
require 'capybara/rspec'

Dir[File.dirname(__FILE__) + '/shared/*.rb'].each {|file| require file }

Capybara.app = Middleman::Application.server.inst do
  set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
  set :environment, :development
  set :show_exceptions, false
end