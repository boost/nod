require 'spec_helper'

RSpec.describe Nod::Client do
  let(:client)   { Nod::Client }
  let(:email)    { ENV['EMAIL'] }
  let(:password) { ENV['PASSWORD'] }

  it 'has a base url endpoint' do
    expect(Nod::Client::BASE_URL).to eql 'https://go.nodmedia.io'
  end

  describe '#initialize' do
    let(:fake_email) { 'test@test.com' }
    let(:fake_password) { 'testo Majesto' }

    before do
      @creds = { email: fake_email, password: fake_password }
    end

    context 'invalid parameters' do
      it 'raises an error if no email is provided' do
        @creds[:email] = nil
        expect{ client.new(@creds) }.to raise_error Nod::AuthenticationError
      end
      it 'raises an error if no password is provided' do
        @creds[:password] = nil
        expect{ client.new(@creds) }.to raise_error Nod::AuthenticationError
      end
      it 'raises an error if the credentials argument is a string' do
        creds = ''
        expect{ client.new(creds) }.to raise_error Nod::AuthenticationError
      end
      it 'raises an error if the credentials argument is an number' do
        creds = 1
        expect{ client.new(creds) }.to raise_error Nod::AuthenticationError
      end
    end

    context 'valid parameters' do
      it 'sets the email' do
        expect(client.new(@creds).email).to eql fake_email
      end
      it 'sets the password' do
        expect(client.new(@creds).password).to eql fake_password
      end
    end
  end

  describe '#authenticate' do
    context 'successful authentication' do
     # todo
    end

    context 'unsuccessful authentication' do
      #todo
    end
  end

  describe '#authenticated?' do
      it 'returns true if the client has successfully authenticated' do
        creds = { email: email, password: password }

        c = client.new(creds)

        # TEMP MOCK
        c.instance_variable_set(:@cookies, true)
        allow_any_instance_of(Nod::Client).to receive(:authenticate).and_return(true)
        # TEMP MOCK END

        c.authenticate

        expect(c.authenticated?).to be true
      end
      it 'returns false if the client has not been authenticated' do
        creds = { email: 'fake@email.com', password: 'notarealpassword' }

        c = client.new(creds)

        expect(c.authenticated?).to be false
      end
  end

  describe '#deploy' do
    context 'AUTHENTICATED' do
      before do
        @auth_client = client.new({email: email, password: password})

        # TEMP MOCK
        @auth_client.instance_variable_set(:@cookies, true)
        @auth_client.instance_variable_set(:@window_code, true)

        allow_any_instance_of(Nod::Client).to receive(:authenticate).and_return(true)
        # TEMP MOCK END

        @auth_client.authenticate

        project_name = 'test-project'

        @mocked_asset = double('asset', class: Nod::Asset, file_path: "#{project_name}_assets.zip")
      end

      it 'returns true when deploy is successful' do
        # stub RestClient post call to return successful response
        post_response = double('response', body: { 'Data' => {} }.to_json)
        allow(RestClient).to receive(:post).and_return(post_response)

        # stub opening a file
        allow(::File).to receive(:open).and_return('I am the data')

        expect(@auth_client.deploy(@mocked_asset)).to be true
      end
      it 'returns false when the deploy is unsuccessful ' do
        # stub RestClient post call to return Nod Error Message
        post_response = double('response', body: {'Error' => 'There was an error performing the requested action.' }.to_json)
        allow(RestClient).to receive(:post).and_return(post_response)

        # stub opening a file
        allow(::File).to receive(:open).and_return('I am the data')

        expect(@auth_client.deploy(@mocked_asset)).to be false
      end
      it 'raises an error if the asset is nil' do
        asset = nil
        expect { @auth_client.deploy(asset) }.to raise_error('No Asset to Deploy!')
      end
      it 'raises an error if the asset file is not a .zip file' do
        unzipped_file = 'unzipped_file.txt'
        allow(@mocked_asset).to receive(:file_path).and_return(unzipped_file)
        expect { @auth_client.deploy(@mocked_asset) }.to raise_error('Bundled Asset must be in .zip format')
      end
    end
  end
end
