
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

      payload = {  'EmailAddress' =>  @email,
                   'Password'     =>  @password }

      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      resp = RestClient.post(login_url, payload.to_json, headers)

      raise Nod::AuthenticationError.new("Invalid Login Credentials") unless successful_response?(resp.body)

      resp
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