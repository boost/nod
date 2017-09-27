
require 'spec_helper'

RSpec.describe BASE_FILES do
  let (:base_files) {BASE_FILES.map {|file| File.basename(file)} }
  
  it 'contains a main javascript file' do
    expect(base_files).to include('main.js')
  end
  it 'contains an index HTML file' do
    expect(base_files).to include('index.html')
  end
  it 'contains a css file for styling' do
    expect(base_files).to include('style.css')
  end
end