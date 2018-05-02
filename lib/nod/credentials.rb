module Nod
  class Credentials

    attr_reader :email, :password

    def initialize(email, password)
      @email = email
      @password = password
    end

    def self.load_from_file(file_path)
      credentials = JSON.parse(::File.read(file_path))

      new credentials['email'], credentials['password']
    end
  end
end