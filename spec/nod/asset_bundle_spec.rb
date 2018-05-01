
require 'spec_helper'

RSpec.describe Nod::AssetBundle do
  let(:asset_bundle) { Nod::AssetBundle }
  let(:project_name) { 'test-project' }

  describe '::new' do
    it 'sets the name attribute' do
      expect(asset_bundle.new(project_name).name).to eql project_name
    end
    it 'sets an empty array for asset files as an attribute' do
      new_asset_bundle = asset_bundle.new(project_name)
      expect(new_asset_bundle.asset_files).to be_a Array
      expect(new_asset_bundle.asset_files.empty?).to be true
    end
    it 'returns an AssetBundle object' do
      expect(asset_bundle.new(project_name)).to be_a asset_bundle
    end
  end

  describe '#bundle' do
    let(:bundled_obj) { asset_bundle.new(project_name) }
    it 'raises an error if the asset does not exist' do
      expect { bundled_obj.bundle }.to raise_error 'Asset doesn\'t exist'
    end
    it 'returns a collection of zipped files' do
      # mock fake asset to exist
      allow_any_instance_of(asset_bundle).to receive(:asset_exists?).and_return(true)

      # mock writing to file
      allow(::File).to receive(:write).and_return(true)

      # mock zipping to file
      files = ['index.html', 'style.css', 'main.js']
      allow(Zip::File).to receive(:open).and_return(files)

      expect(bundled_obj.bundle).to eql files
    end
  end

  describe '::find' do
    it 'raises an error if asset bundle cannot be found' do
      unknown_project = 'not-a-project.zip'
      expect { asset_bundle.find(unknown_project) }.to raise_error 'Asset doesn\'t exist'
    end

    context 'found AssetBundle object' do
      before(:each) do
        # mock fake asset bundle to exist (to return a true value)
        allow_any_instance_of(Nod::Helpers).to receive(:asset_exists?).and_return(true)

        # mock fake asset bundle to be the right file type
        allow(asset_bundle).to receive(:correct_bundle_file_type?).and_return(true)

        # mock a successful file read
        allow(::File).to receive(:read).and_return(true)
      end

      it 'returns an AssetBundle object' do
        expect(asset_bundle.find(project_name)).to be_a Nod::AssetBundle
      end
      it 'gives the asset bundle a file path attribute' do
        bundle = asset_bundle.find(project_name)

        # be_truthy is a bit misleading
        expect(bundle.file_path).to be_truthy
      end
      it 'gives the asset bundle a file attribute' do
        bundle = asset_bundle.find(project_name)

        # be_truthy is a bit misleading
        expect(bundle.file).to be_truthy
      end
    end
  end

  describe '#list_files' do
    let(:files) { ['index.html', 'style.css', 'main.js'] }
    let(:bundled_obj) do
      asset             = asset_bundle.new('bundle')
      asset.file_path   = '/bundle.zip'
      asset.file        = 'data in the file'
      asset.asset_files = files
      asset
    end

    before do
      # mock AssetBundle class find method
      allow(asset_bundle).to receive(:find).and_return(bundled_obj)

      @bundle = asset_bundle.find(project_name)
    end
    it 'returns a collection of all files in the asset bundle' do
      expect(@bundle.list_files).to eql files
    end
    it 'returns an empty collection if the asset bundle is empty' do
      @bundle.asset_files = []

      expect(@bundle.list_files).to eql []
    end
  end
end