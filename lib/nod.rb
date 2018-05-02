require 'pry'
require "nod/helpers"
require "nod/root"
require "nod/version"
require "nod/asset_bundle"
require "nod/file"
require "nod/asset"
require "nod/client"
require "nod/credentials"
require "nod/asset"
require 'nokogiri'
require 'thor'
require 'zip'
require 'mime-types'
require 'rest-client'
require 'json'

module Nod
  class Runner < Thor
    desc 'init <name>', 'Creates a new template'
    def init(name, *args)
      Nod::Asset.create_new_project(name)
    end

    desc 'bundle <name>', 'Creates a .zip file of a project\'s assets'
    def bundle(name, *args)
      asset = Nod::AssetBundle.new(name)
      asset.bundle
    end

    desc 'deploy <asset-name>', 'Deploy files to a specific asset'
    def deploy(name, *args)
      creds = Nod::Credentials.load_from_file('./credentials.json')

      client = Nod::Client.new(creds)
      client.authenticate

      asset_bundle = Nod::AssetBundle.find(name)

      client.deploy(asset_bundle)
    end
  end
end
