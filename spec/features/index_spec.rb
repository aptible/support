require 'spec_helper'

describe 'index', type: :feature do
  before do
    visit '/'
  end

  it 'has a large search bar' do
    page.should have_selector '#swifttype-search-input'
  end

  it 'has the correct page title' do
    page.should have_selector 'h1'
    within 'h1' do
      page.should have_content /Aptible Support/
    end
  end
end