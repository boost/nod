module Nod
  # lib/nod/asset.rb
  class Asset
    def initialize(name)
      @name = name
    end

    def bundle
      raise "Asset doesn't exists." unless asset_exists?(@name)
      files = Dir[File.join([Dir.pwd, "/#{@name}/*"])]
      zip_file_name = "#{@name}_assets.zip"
      Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          zipfile.add(File.basename(file), file)
        end
      end
    end

    def asset_exists?(name)
      Dir.new(Dir.pwd).each do |x|
        return true if x == name
      end
      false
    end
  end
end
