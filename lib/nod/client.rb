
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
          redirect     = response.follow_get_redirection
          @cookies     = redirect.cookies
          @window_code = response.headers[:location].delete('/')
          redirect
        else
          # raise exception
          raise Nod::AuthenticationError.new('Invalid Login Credentials')
        end
      end
    end

    def authenticated?
      !!@cookies rescue false
    end

    def deploy(asset)
      raise 'Client has not been successfully authenticated!' unless authenticated?
      raise 'No Asset to Deploy!' if asset.nil?
      raise 'Bundled Asset must be in .zip format' unless asset.file_path.include? '.zip'
      raise 'Unset Window Code' unless @window_code

      url     = BASE_URL + "/upload/asset?windowCode=#{@window_code}"

      file    = ::File.open(asset.file_path)

      payload = {
        file: file
      }

      # make request to Nod Backend
      response      = RestClient.post(url, payload, cookies: @cookies)

      # parse JSON response
      response_body = JSON.parse(response.body)

      # return if the deployment went well or not
      response_body['Error'] ? false : true
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