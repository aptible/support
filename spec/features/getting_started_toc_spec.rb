require 'spec_helper'
require 'yaml'

describe 'Getting Started Table of Contents', type: :feature do
  file = "#{File.dirname(__FILE__)}/../../data/getting_started.yml"
  toc = YAML.load_file file

  it_behaves_like 'a table of contents', toc, '/getting_started'
end
