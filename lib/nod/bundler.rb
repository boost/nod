
module Nod
  class Asset
    class Bundler
      include Helpers

      def initialize(name)
        @name = name
      end

      def bundle
        raise "Asset doesn't exists." unless asset_exists?(@name)

        file_paths = Dir[::File.join([Dir.pwd, "/#{@name}/*"])]

        files = file_paths.map do |file|
          file_name = ::File.basename(file)
          mime_type = ::MIME::Types.type_for(file).first.to_s
          Nod::File.new(file_name, file_name, mime_type)
        end

        xml = generate_xml(files)
        manifest = generate_manifest(xml)
        file_paths.push( manifest )

        zip_assets(file_paths)
      end

      private

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
          xml.root do
            xml.assets(name: @name, type: "html", orientation: "LANDSCAPE") do
              xml.files do 
                files.each do |file|
                  xml.file(name: file.name, filename: file.file_name, "mime-type" => file.mime_type, orientation: file.orientation)
                end
              end
            end
          end
        end

        builder.to_xml
      end
    end
  end
end