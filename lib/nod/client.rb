
module Nod
  class Client
    BASE_URL = 'https://go.nodmedia.io'

    def initialize(email, password)
      @email = email
      @password = password
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

    def list_assets
      raise AuthenticationError.new('Client has not been successfully authenticated!') unless authenticated?

      assets_endpoint = '/api/asset/list?windowCode='

      url = [BASE_URL, assets_endpoint, @window_code].join('')

      response = RestClient.get(url, cookies: @cookies)

      JSON.parse(response.body)['Data']
    end

    def list_data_feeds
      raise AuthenticationError.new('Client has not been successfully authenticated') unless authenticated?

      data_feeds_endpoint = '/api/feed/list?windowCode='

      url = [BASE_URL, data_feeds_endpoint, @window_code].join('')

      response = RestClient.get(url, cookies: @cookies, content_type: 'application/json')

      JSON.parse(response.body)['Data']
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