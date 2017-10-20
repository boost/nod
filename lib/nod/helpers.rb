module Nod
  # lib/nod/helpers.rb
  module Helpers

    # make helper methods, class methods
    def Helpers.included(mod)
      mod.extend Helpers
    end

    def asset_exists?(name)
      Dir.new(Dir.pwd).each do |asset|
        return true if asset == name
      end
      false
    end
  end
end