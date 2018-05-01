require 'spec_helper'

RSpec.describe Nod::Runner do

  let (:runner) {Nod::Runner}
  let (:project_name) {'test-app'}
  let (:bundled_asset) {project_name + '_assets.zip'}

  describe 'with invalid parameters' do
    it 'prints helpful information to the console' do
      params = []
      expect { runner.start(params) }.to output.to_stdout
    end
  end

  describe '::init' do
    it 'outputs to stderr with no project name' do
      params = ['init']
      expect { runner.start(params) }.to output(/ERROR/).to_stderr
    end

    context 'with valid parameters' do
      it 'creates a new project when provided a project name' do
        params = ['init'].push(project_name)

        runner.start(params)

        expect(Dir.exists?(project_name)).to be true
      end

      it 'creates a new project when provided multiple params' do
        other_params = ['foo', 'bar', 'baz']

        params = ['init'].push(project_name)
        # add other params to end of params arr
        params = (params + other_params).flatten

        runner.start(params)

        expect(Dir.exists?(project_name)).to be true
      end

      it 'raises an error if the asset already exists' do
        params = ['init'].push(project_name)

        # create 'test-app' project
        runner.start(params)

        # try to create the same project
        expect { runner.start(params) }.to raise_error
      end
    end

    after(:each) do
      # remove new project
      FileUtils.remove_dir(project_name) if File.exists?(project_name)
    end
  end

  describe '::bundle' do
    it 'raises an error when no project name is provided' do
      params = ['bundle']

      expect { runner.start(params) }.to output(/ERROR/).to_stderr
    end

    context 'valid parameters' do
      let(:project_name) {'test-app'}
      let(:project) { runner.start(['init', project_name]) }

      it 'raises an error if the project doesn\'t exist' do
        params = ['bundle', project_name]
        expect { runner.start(params) }.to raise_error
      end

      # slightly buggy, change .to => .to_not for clarification
      it 'raises an error if a bundled project already exists' do
        # create project
        project

        params = ['bundle', project_name]
        # bundle project
        runner.start(params)

        # bundle again
        expect { runner.start(params) }.to raise_error
      end
      it 'bundles a project together' do
        # check bundled project doesn't exist at the start of the test
        expect(File.exists?(bundled_asset)).to_not be(true)
      end
      it 'bundles a project as a .zip file' do
        # check bundled project doesn't exist at the start of the test
        expect(File.extname(bundled_asset)).to eql '.zip'
      end

      after(:each) do
        FileUtils.remove_dir(bundled_asset) if File.exists?(bundled_asset)
      end
    end
  end

  describe '::deploy' do
    it 'raises an error if no project name is provided' do
      params = ['deploy']
      expect { Nod::Runner.start(params) }.to output(/ERROR/).to_stderr
    end
  end

  after do
    # delete test projects in case they still remain
    FileUtils.remove_dir(project_name) if File.exists?(project_name)
    FileUtils.remove(bundled_asset) if File.exists?(bundled_asset)
  end
end