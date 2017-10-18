module Nod
  # lib/nod/asset.rb
  class Asset
    extend Helpers

    BASE_FILES = Dir[::File.join([::File.dirname(::File.expand_path(__FILE__)), 'base-files/*'])]

    def self.create_new_project(name)
      create_asset_directory(name)
      BASE_FILES.each do |file|
        # TODO change ::File
        path = ::File.join([Dir.pwd, name, ::File.basename(file)])
        puts "Creating: '#{file}'"
        FileUtils.cp(file, path)
        puts "Successfully created: '#{file}'"
      end
    end

    def self.create_asset_directory(name)
      raise 'Asset already exists.' if asset_exists?(name)
      Dir.mkdir(name)
    end
  end
end
