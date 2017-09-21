require 'pry'
require "nod/helpers"
require "nod/base_files"
require "nod/version"
require "nod/initializer"
require "nod/bundler"
require "nod/file"
require "nod/asset"
require 'nokogiri'
require 'thor'
require 'zip'
require 'mime-types'

module Nod
  class Runner < Thor 
    desc 'init <name>', 'Creates a new template'
    def init(name, *args)
      asset = Nod::Asset::Initializer.new(name)
      asset.create_new_project
    end

    desc 'bundle <name>', 'Creates a .zip file of a project\'s assets' 
    def bundle(name, *args)
      asset = Nod::Asset::Bundler.new(name)
      asset.bundle
    end

    # TODO
    # desc 'deploy <asset-name>', 'Deploy files to a specific asset'
    # def deploy(name, *args)
    # end
  end
end
