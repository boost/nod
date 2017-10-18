
module Nod
  class AssetBundle
    include Helpers

    def initialize(name)
      @name = name
    end

    def bundle
      raise "Asset doesn't exists." unless asset_exists?(@name)

      file_paths = Dir[::File.join([Dir.pwd, "/#{@name}/*"])]

      files = file_paths.map do |file|
        file_name   = ::File.basename(file)
        mime_type   = ::MIME::Types.type_for(file).first.to_s
        type        = generate_type(mime_type)
        orientation = 'LANDSCAPE'
        Nod::File.new(file_name, file_name, mime_type, type, orientation)
      end

      xml = generate_xml(files)
      manifest = generate_manifest(xml)
      file_paths.push( manifest )

      zip_assets(file_paths)
    end

    private

    def zip_assets(files)
      file_path = "#{@name}_assets.zip"
      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        files.each do |file|
          zipfile.add(::File.basename(file), file)
        end
      end
    end

    def generate_type(mime_type)
      if mime_type == 'text/html'
        'html'
      else
        'ancillary'
      end
    end

    def generate_manifest(xml)
      curr_dir = Dir.pwd
      asset_dir = @name
      manifest_file = 'manifest.xml'
      write_file = ::File.join([curr_dir, asset_dir, manifest_file])

      ::File.write(write_file, xml)
      write_file
    end

    def generate_xml(files)
      builder = ::Nokogiri::XML::Builder.new do |xml|
        xml.assets(name: @name, type: "html", orientation: "LANDSCAPE", await: 'timeout', timeout: '20000') do
          xml.files do
            files.each do |file|
              xml.file(name: file.name, filename: file.file_name, "mime-type" => file.mime_type, orientation: file.orientation, type: file.type)
            end
          end
        end
      end

      builder.to_xml
    end
  end
end