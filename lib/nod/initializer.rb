module Nod
  class Asset
    # lib/nod/initializer.rb
    class Initializer
      include Nod::Helpers

      def initialize(name)
        @name = name
      end

      def create_new_project
        create_asset_directory
        BASE_FILES.each do |file|
          # TODO change ::File
          path = ::File.join([Dir.pwd, @name, ::File.basename(file)])
          puts "Creating: '#{file}'"
          FileUtils.cp(file, path)
          puts "Successfully created: '#{file}'"
        end
      end

      def create_asset_directory
        raise 'Asset already exists.' if asset_exists?(@name)
        Dir.mkdir(@name)
      end
    end
  end
end
