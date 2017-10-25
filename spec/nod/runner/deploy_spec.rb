
require 'spec_helper'

RSpec.describe Nod::Runner do
  let(:runner) { Nod::Runner }

  describe '::deploy' do
    let(:project_name) { 'test-app' }
    let(:params) { ['deploy', project_name] }
    let(:bundled_project) do
      double(project_name, name: project_name, class: Nod::AssetBundle, file_path: (project_name + '_assets.zip'))
    end

    it 'raises an error if provided no project name' do
      params = ['deploy']
      expect { runner.start(params) }.to output(/ERROR/).to_stderr
    end

    it 'returns a true value if the deployment was successful'

    context 'unsuccessful deployment' do
      it 'raises an error if the client is not authenticated' do
        # mock instance of Nod::Client to not be authenticated

        # (return a value here that replicates an unsuccessful auth)
        allow_any_instance_of(Nod::Client).to receive(:authenticate)

        # find fake AssetBundle object
        allow(Nod::AssetBundle).to receive(:find).and_return(bundled_project)

        params = ['deploy', project_name]

        expect { runner.start(params) }.to raise_error 'Client has not been successfully authenticated!'
      end
      it 'raises an error if the project cannot be found' do
        mocked_successful_auth = double('RestClient::Response', code: 200, body: '<body>Fake Response</body>')

        # mock instance of Nod::Client to be authenticated
        allow_any_instance_of(Nod::Client).to receive(:authenticate).and_return(mocked_successful_auth)

        fake_project = 'fake-project'

        expect { Nod::AssetBundle.find(fake_project) }.to raise_error "Asset doesn't exist"
      end
      it 'raises an error if deploying the project failed' do
        mocked_successful_auth = double('RestClient::Response', code: 200, body: '<body>Fake Response</body>')

        # mock instance of Nod::Client to be authenticated
        allow_any_instance_of(Nod::Client).to receive(:authenticate).and_return(mocked_successful_auth)

        mocked_project = instance_double('Nod::AssetBundle')

        allow(Nod::AssetBundle).to receive(:find).and_return(mocked_project)

        # stub RestClient post method to fail
        allow(RestClient).to receive(:post).and_return()
      end
    end
  end
end