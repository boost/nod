module Nod
  class Asset
    # lib/nod/initializer.rb
    class Initializer
      def initialize(name)
        @name = name
      end

      def create_new_project
        create_asset_directory
        BASE_FILES.each do |file|
          path = File.join([Dir.pwd, @name, File.basename(file)])
          puts "Creating: '#{file}'"
          FileUtils.cp(file, path)
          puts "Successfully created: '#{file}'"
        end
      end

      def create_asset_directory
        raise 'Asset already exists.' if asset_exists?(@name)
        Dir.mkdir(@name)
      end

      def asset_exists?(name)
        Dir.new(Dir.pwd).each do |x|
          return true if x == name
        end
        false
      end
    end
  end
end
