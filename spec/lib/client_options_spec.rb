require 'spec_helper'

class TestSoapObjectWithProperties
  include SoapObject

  wsdl 'http://blah.com'
  proxy 'http://proxy.com:8080'
  open_timeout 10
  read_timeout 20
  soap_header 'Token' => 'secret'
  encoding 'UTF-16'
  basic_auth 'steve', 'secret'
  digest_auth 'digest', 'auth'
  log_level :error
  soap_version 2
end

class WithoutClientProperties
  include SoapObject
end

describe SoapObject do
  let(:client) { double('client') }

  before do
    allow(Savon).to receive(:client).and_return(client)
  end

  context 'when creating new instances' do

    let(:subject) { TestSoapObjectWithProperties.new }

    it 'should initialize the client using the wsdl' do
      expect(subject.send(:client_properties)[:wsdl]).to eq('http://blah.com')
    end

    it 'should know when it is connected to service' do
      expect(subject).to be_connected
    end

    it 'should allow one to setup a proxy' do
      expect(subject.send(:client_properties)[:proxy]).to eq('http://proxy.com:8080')
    end

    it 'should allow one to set an open timeout' do
      expect(subject.send(:client_properties)[:open_timeout]).to eq(10)
    end

    it 'should allow one to set a read timeout' do
      expect(subject.send(:client_properties)[:read_timeout]).to eq(20)
    end

    it 'should allow one to set a soap header' do
      expect(subject.send(:client_properties)[:soap_header]).to eq({'Token' => 'secret'})
    end

    it 'should allow one to set the encoding' do
      expect(subject.send(:client_properties)[:encoding]).to eq('UTF-16')
    end

    it 'should allow one to use basic authentication' do
      expect(subject.send(:client_properties)[:basic_auth]).to eq(['steve', 'secret'])
    end

    it 'should allow one to use digest authentication' do
      expect(subject.send(:client_properties)[:digest_auth]).to eq(['digest', 'auth'])
    end

    it 'should enable logging when logging level set' do
      expect(subject.send(:client_properties)[:log]).to eq(true)
    end

    it 'should allow one to set the log level' do
      expect(subject.send(:client_properties)[:log_level]).to eq(:error)
    end

    it 'should use pretty format for xml when logging' do
      expect(subject.send(:client_properties)[:pretty_print_xml]).to eq(true)
    end

    it 'should allow one to set the soap version' do
      expect(subject.send(:client_properties)[:soap_version]).to eq(2)
    end

  end

  context 'when creating new instances with out client property overrides' do
    let(:subject) { WithoutClientProperties.new }

    it 'should set SSL version to 3 by default' do
      expect(subject.send(:client_properties)[:ssl_version]).to eq(:SSLv3)
    end

    it 'should disable SSL verification by default' do
      expect(subject.send(:client_properties)[:ssl_verify_mode]).to eq(:none)
    end

    it 'should disable logging by default' do
      expect(subject.send(:client_properties)[:log]).to eq(false)
    end
  end
end
