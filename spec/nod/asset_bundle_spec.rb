
require 'spec_helper'

RSpec.describe Nod::AssetBundle do
  let(:asset_bundle) { Nod::AssetBundle }
  let(:project_name) { 'test-project' }
  describe '::find' do
    it 'raises an error if asset bundle cannot be found' do
      unknown_project = 'not-a-project.zip'
      expect { asset_bundle.find(unknown_project) }.to raise_error 'Asset doesn\'t exist'
    end
    it 'raises an error if the asset bundle is not in .zip format' do
      # mock fake asset to exist (to return a true value)
      allow_any_instance_of(Nod::Helpers).to receive(:asset_exists?).and_return(true)

      text_file = 'file.txt'
      expect { asset_bundle.find(text_file) }.to raise_error 'Incorrect Bundle File type'
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
end