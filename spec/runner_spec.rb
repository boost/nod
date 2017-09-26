require 'spec_helper'

RSpec.describe Nod::Runner do

  let (:runner) {Nod::Runner}

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
        project_name = 'test-app'
        params = ['init'].push(project_name)

        runner.start(params)

        expect(Dir.exists?(project_name)).to be true

        # remove new project
        FileUtils.remove_dir(project_name)
      end

      it 'creates a new project when provided multiple params' do
        project_name = "test-app"
        other_params = ['foo', 'bar', 'baz']

        params = ['init'].push(project_name)
        # add other params to end of params arr
        params = (params + other_params).flatten

        runner.start(params)

        expect(Dir.exists?(project_name)).to be true

        # remove new project
        FileUtils.remove_dir(project_name)
      end
    end
  end
end