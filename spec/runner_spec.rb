require 'spec_helper'

RSpec.describe Nod::Runner do

  let (:runner) {Nod::Runner}
  let (:project_name) {'test-app'}

  describe 'with invalid parameters' do
    it 'prints helpful information to the console' do
      params = []
      expect { runner.start(params) }.to output.to_stdout
    end
  end

  describe '::init' do
    it 'outputs to stderr with no project name' do
      params = ['init']
      expect{ runner.start(params) }.to output(/ERROR/).to_stderr
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
end