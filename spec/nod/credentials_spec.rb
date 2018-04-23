require 'spec_helper'

RSpec.describe Nod::Credentials, fakefs: true do

  let(:email) { 'test@test.test' }
  let(:password) { 'password12345' }

  describe '#initialize' do
    let (:credentials) { described_class.new(email, password) }

    it 'sets the email' do
      expect(credentials.email).to eql email
    end

    it 'sets the password' do
      expect(credentials.password).to eql password
    end
  end

  describe '::load_from_file' do
    let(:file) { 'test-credentials.json' }

    before do
      File.write(file, "{ \"email\": \"#{email}\", \"password\": \"#{password}\" }")
    end

    it 'creates an instance of `Nod::Credentials`' do
      expect(Nod::Credentials.load_from_file(file)).to be_instance_of Nod::Credentials
    end
  end
end