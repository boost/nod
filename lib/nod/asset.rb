module Nod
  # lib/nod/asset.rb
  class Asset
    extend Helpers

    BASE_FILES = Dir[::File.join([Nod.root, 'base-files/*'])]

    def self.create_new_project(name)
      create_asset_directory(name)
      BASE_FILES.each do |file|
        # TODO change ::File
        path = ::File.join([Dir.pwd, name, ::File.basename(file)])
        puts "Creating: '#{path}'"
        FileUtils.cp(file, path)
        puts "Successfully created: '#{path}'"
      end
    end

    def self.create_asset_directory(name)
      raise 'Asset already exists.' if asset_exists?(name)
      Dir.mkdir(name)
    end
  end
end
