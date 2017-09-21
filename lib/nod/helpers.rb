module Nod
  # lib/nod/helpers.rb
  module Helpers
    def zip_assets(files)
      file_path = "#{@name}_assets.zip"
      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          zipfile.add(::File.basename(file), file)
        end
      end
    end

    def asset_exists?(name)
      Dir.new(Dir.pwd).each do |asset|
        return true if asset == name
      end
      false
    end
  end
end