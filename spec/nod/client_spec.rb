require 'spec_helper'

RSpec.describe Nod::Client do
  let(:client) { Nod::Client }

  it 'has a base url endpoint' do
    expect(Nod::Client::BASE_URL).to eql 'https://go.nodmedia.io'
  end

  describe '#initialize' do
    let(:email) { 'test@test.com' }
    let(:password) { 'testo Majesto' }

    before do
      @creds = { email: email, password: password }
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
        expect(client.new(@creds).email).to eql email
      end
      it 'sets the password' do
        expect(client.new(@creds).password).to eql password
      end
    end
  end

  describe '#authenticate' do
    context 'successful authentication' do
      it 'returns a 200 HTTP status code' do
        email    = ENV['EMAIL']
        password = ENV['PASSWORD']
        creds = { email: email, password: password }
        expect(client.new(creds).authenticate.code).to eql 200
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
  end
end
