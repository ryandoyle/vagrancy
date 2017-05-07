require 'spec_helper'
require 'vagrancy/plugin/content_server'

describe Vagrancy::Plugin::ContentServer do

  class TestingContentServer < Vagrancy::Plugin::ContentServer
    path '/somepath'
    verb :put
  end

  describe '#verb' do
    it 'returns the method registered' do
      expect(TestingContentServer.new.verb).to eq :put
    end
    it 'defaults to a :get if not set' do
      expect(described_class.new.verb).to eq :get
    end
  end

  describe '#path' do
    it 'returns the path registered with the plugin' do
      expect(TestingContentServer.new.path).to eq '/somepath'
    end
  end

end