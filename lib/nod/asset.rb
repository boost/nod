module Nod
  # lib/nod/asset.rb
  class Asset
    BASE_FILES = Dir[::File.join([::File.dirname(::File.expand_path(__FILE__)), 'base-files/*'])]
  end
end
