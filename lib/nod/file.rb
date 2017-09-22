
module Nod
  class File
    attr_reader :name, :file_name, :mime_type, :orientation, :type
    def initialize(name, file_name, mime_type, type, orientation)
      @name = name
      @file_name = file_name
      @mime_type = mime_type
      @type      = type
      @orientation = orientation
    end
  end
end