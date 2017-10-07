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
      before do
        @creds = { email: email, password: password }
      end

      it 'returns a 200 HTTP status code' do
        expect(client.new(@creds).authenticate.code).to eql 200
      end

      it 'returns authentication cookies' do
        # be more specific about the expectation than just a truthy value
        expect(client.new(@creds).authenticate.cookies).to be_truthy
      end

      it 'sets the cookie as an accessible attribute' do
        # auth
        c = client.new(@creds).authenticate

        # be more specific about the expectation than just a truthy value
        expect(c.cookies).to be_truthy
      end
    end
    context 'unsuccessful authentication' do
      it 'raises an error if the authentication fails' do
        email    = 'fake@email.com'
        password = 'notarealpassword'
        creds = { email: email, password: password }
        expect { client.new(creds).authenticate.code }.to raise_error Nod::AuthenticationError
      end
    end

    after do
      email    = ENV['EMAIL']
      password = ENV['PASSWORD']
      creds    = { email: email, password: password }
      # perform successful authentication
      # to refresh Nod auth status.
      # too many unsuccessful authentications
      # equals disabled account. Not fun.
      client.new(creds).authenticate
    end
  end

  describe '#authenticated?' do
      it 'returns true if the client has successfully authenticated' do
        creds = { email: email, password: password }

        c = client.new(creds)
        c.authenticate

        expect(c.authenticated?).to be true
      end
      it 'returns false if the client has not been authenticated' do
        creds = { email: 'fake@email.com', password: 'notarealpassword' }

        c = client.new(creds)

        expect(c.authenticated?).to be false
      end
  end
end
