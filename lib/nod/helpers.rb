module Nod
  # lib/nod/helpers.rb
  module Helpers

    def asset_exists?(name)
      Dir.new(Dir.pwd).each do |asset|
        return true if asset == name
      end
      false
    end
  end
end