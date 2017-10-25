require 'pry'
require "nod/helpers"
require "nod/root"
require "nod/version"
require "nod/asset_bundle"
require "nod/file"
require "nod/asset"
require "nod/client"
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
      # retrieve credentials from ENVIRONMENT
      email    = ENV['EMAIL']
      password = ENV['PASSWORD']

      # generate Nod client
      client   = Nod::Client.new({ email: email, password: password })

      # authenticate client
      client.authenticate

      # find Nod Asset Bundle
      project  = Nod::AssetBundle.find(name)

      # deploy project (asset bundle)
      client.deploy(project)
    end
  end
end
