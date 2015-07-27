require 'spec_helper'

require 'vagrancy/filestore_configuration'

describe Vagrancy::FilestoreConfiguration do

  let(:filestore_configuration) { described_class.new }

  describe '#path' do

    before do
      allow(File).to receive(:dirname).with(anything).and_return '/a/b/c/d/e'
      allow(File).to receive(:expand_path).with('/a/b/c/d/e/../../').and_return '/a/b/c'
      allow(File).to receive(:expand_path).with('/a/b/c/d/e/../../../../').and_return '/a'
    end

    describe  'when run as a normal application' do
      before do
        allow(File).to receive(:exists?).with('/a/vagrancy').and_return false
      end

      it 'should get the path from configuration file if it exists' do
        allow(File).to receive(:exists?).with('/a/b/c/config.yml').and_return true
        allow(File).to receive(:read).with('/a/b/c/config.yml').and_return 'filestore_path: /some/full/path/'

        expect(filestore_configuration.path).to eql '/some/full/path/'
      end

      it 'should be a full path' do
        allow(File).to receive(:exists?).with('/a//b/c/config.yml').and_return true
        allow(File).to receive(:read).with('/a/b/c/config.yml').and_return 'filestore_path: relative_path/'

        expect{filestore_configuration.path}.to raise_error
      end

      it 'should always have a trailing slash' do
        allow(File).to receive(:exists?).with('/a/b/c/config.yml').and_return true
        allow(File).to receive(:read).with('/a/b/c/config.yml').and_return 'filestore_path: /some/full/path'


        expect(filestore_configuration.path).to eql '/some/full/path/'
      end

      it 'should default to the root of the project if not configured' do
        allow(File).to receive(:exists?).with('/a/b/c/config.yml').and_return false

        expect(filestore_configuration.path).to eql '/a/b/c/data/'
      end
    end

    describe 'when packaged as a standalone application' do
      before do
        allow(File).to receive(:exists?).with('/a/vagrancy').and_return true
      end

      it 'should get the path from configuration file if it exists' do
        allow(File).to receive(:exists?).with('/a/config.yml').and_return true
        allow(File).to receive(:read).with('/a/config.yml').and_return 'filestore_path: /some/full/path/'

        expect(filestore_configuration.path).to eql '/some/full/path/'
      end

      it 'should default to the root of the standalone application if not configured' do
      allow(File).to receive(:exists?).with('/a/config.yml').and_return false

      expect(filestore_configuration.path).to eql '/a/data/'
      end
    end
  end

end
