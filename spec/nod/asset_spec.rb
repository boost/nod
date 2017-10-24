
require 'spec_helper'

RSpec.describe Nod::Asset, fakefs: true do
  let(:asset) { Nod::Asset }
  let(:project_name) { 'test-project' }

  describe '::create_new_project' do
    before do
      base_files = ::File.join([Nod.root, '/base-files/*'])

      # include base files in fake file system
      FakeFS::FileSystem.clone(base_files)

      asset.create_new_project(project_name)

      # start fake file system
      FakeFS.activate!
    end

    it 'creates a directory for the project' do
      expect(Dir.exists?(project_name)).to be true
    end
    it 'creates an index.html file' do
      file_path = ::File.join([project_name, 'index.html'])
      expect(::File.exist?(file_path))
    end
    it 'creates a style.css file' do
      file_path = ::File.join([project_name, 'style.css'])
      expect(::File.exist?(file_path))
    end
    it 'creates a main.js file' do
      file_path = ::File.join([project_name, 'main.js'])
      expect(::File.exist?(file_path))
    end

    after do
      # stop fake file system
      FakeFS.deactivate!
    end
  end
end