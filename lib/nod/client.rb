
module Nod
  class Client
    BASE_URL = 'https://go.nodmedia.io'

    attr_reader :email, :password

    def initialize(credentials)
      raise AuthenticationError.new('Provided credentials not in hash format') if credentials.class != Hash
      raise AuthenticationError.new('Please provide email') if credentials[:email].nil?
      raise AuthenticationError.new('Please provide password') if credentials[:password].nil?

      @email = credentials[:email]
      @password = credentials[:password]
    end

    def authenticate
      login_url = BASE_URL + '/Member/Login'

      payload = {  'EmailAddress'=>  @email,
                   'Password'    =>  @password }

      RestClient.post(login_url, payload) do |response|
        # follow redirect
        if [301, 302, 307].include? response.code
          redirect = response.follow_get_redirection
          @cookies = redirect.cookies
          redirect
        else
          # raise exception
          raise Nod::AuthenticationError.new("Invalid Login Credentials")
        end
      end
    end
  end
end

module Nod
  class AuthenticationError < StandardError
    def initialize(error)
      @error = error
      super
    end
  end
end