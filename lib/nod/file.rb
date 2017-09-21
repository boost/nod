
module Nod
  class File
    attr_reader :name, :file_name, :mime_type, :orientation
    def initialize(name, file_name, mime_type, orientation = 'LANDSCAPE')
      @name = name
      @file_name = file_name
      @mime_type = mime_type
      @orientation = orientation
    end
  end
end