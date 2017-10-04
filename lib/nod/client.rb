
module Nod
  class Client
    BASE_URL = 'https://go.nodmedia.io'

    attr_reader :email, :password

    def initialize(credentials)
      raise AuthenticationError.new('Provided credentials not in has format') if credentials.class != Hash
      raise AuthenticationError.new('Please provide email') if credentials[:email].nil?
      raise AuthenticationError.new('Please provide password') if credentials[:password].nil?

      @email = credentials[:email]
      @password = credentials[:password]
    end

    def authenticate
      login_url = BASE_URL + '/Member/Login'

      payload = {  'EmailAddress'=>  @email,
                   'Password'    =>  @password }

      headers = { content_type: 'multipart/form-data' }

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

    private

    def successful_response?(resp)
      # parse response string into Nokogiri obj
      page = ::Nokogiri::HTML(resp)

      # Try and find elements in the HTML response 
      # that have the .ui-errormessage class.
      # If the collection of elements returned
      # from that search is greater than 0,
      # an error has occured.
      page.css('.ui-errormessage').length > 0 ? false : true
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