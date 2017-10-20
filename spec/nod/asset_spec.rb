
require 'spec_helper'

RSpec.describe Nod::Asset, fakefs: true do
  let(:asset) { Nod::Asset }
  let(:project_name) { 'test-project' }

  describe '::create_new_project' do
    before do
      base_files = ::File.join([Nod.root, '/base-files/*'])

      # include base files in fake file system
      FakeFS::FileSystem.clone(base_files)
    end

    it 'creates a directory for the project' do
        asset.create_new_project(project_name)

        expect(Dir.exists?(project_name)).to be true
    end
  end
end