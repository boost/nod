
module Nod
  class AssetBundle
    include Helpers

    attr_accessor :file_path, :file, :name, :asset_files

    def initialize(name)
      @name        = name
      @asset_files = []
    end

    def bundle
      raise "Asset doesn't exist" unless asset_exists?(@name)

      @asset_files = Dir[::File.join([Dir.pwd, "/#{@name}/*"])]

      files = @asset_files.map do |file|
        file_name   = ::File.basename(file)
        mime_type   = ::MIME::Types.type_for(file).first.to_s
        type        = generate_type(mime_type)
        orientation = 'LANDSCAPE'
        Nod::File.new(file_name, file_name, mime_type, type, orientation)
      end

      xml = generate_xml(files)
      manifest = generate_manifest(xml)
      @asset_files.push(manifest)

      zip_assets(@asset_files)
    end

    def list_files
      @asset_files
    end

    def self.find(bundle_name)
      raise 'Asset doesn\'t exist' unless asset_exists?(bundle_name)

      # generate file path
      file_path = generate_file_path(bundle_name)

      # check file if it can be read
      raise 'Incorrect Bundle File type' unless correct_bundle_file_type?(file_path)

      # read file
      file = read_file(file_path)

      asset_bundle           = new(bundle_name)
      asset_bundle.file_path = file_path
      asset_bundle.file      = file
      asset_bundle
    end

    # private class methods

    class << self
      private

      def generate_file_path(bundle_name)
        Dir.pwd + bundle_name
      end

      def read_file(file_path)
        ::File.read(file_path)
      end

      def correct_bundle_file_type?(bundle_file)
        bundle_file.include?(".zip") ? true : false
      end
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