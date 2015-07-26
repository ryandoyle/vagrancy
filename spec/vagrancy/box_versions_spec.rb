require 'spec_helper'

require 'vagrancy/box_versions' 

describe Vagrancy::BoxVersions do


  let(:box) { double('Box') }
  let(:filestore) { double('Filestore') }
  let(:request) { double('Request') }
  let(:box_versions) { described_class.new(box, filestore, request) }
  let(:version1) { double('BoxVersion', :exists? => true, :to_h => {:version => '1'}) }
  let(:version2) { double('BoxVersion', :exists? => true, :to_h => {:version => '2'}) }

  before do
    allow(Vagrancy::BoxVersion).to receive(:new).with('1', box, filestore, request).and_return version1
    allow(Vagrancy::BoxVersion).to receive(:new).with('2', box, filestore, request).and_return version2
  end

  describe '#to_a' do


    it 'returns a list of box versions' do
      allow(box).to receive(:path).and_return ('user/box')
      allow(filestore).to receive(:directories_in).with('user/box').and_return ['1', '2']

      expect(box_versions.to_a).to eql([{:version => '1'}, {:version => '2'}])
    end
    it 'only returns versions that exist' do
      allow(box).to receive(:path).and_return ('user/box')
      allow(filestore).to receive(:directories_in).with('user/box').and_return ['1', '2']
      allow(version1).to receive(:exists?).and_return false

      expect(box_versions.to_a).to eql([{:version => '2'}])
    end
  end

end
