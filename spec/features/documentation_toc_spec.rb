require 'spec_helper'
require 'yaml'

describe 'Documentation Table of Contents', type: :feature do
  file = "#{File.dirname(__FILE__)}/../../data/documentation.yml"
  toc = YAML.load_file file

  it_behaves_like 'a table of contents', toc, '/documentation'
end
