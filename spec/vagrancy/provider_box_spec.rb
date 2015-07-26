require 'spec_helper'

require 'vagrancy/provider_box'

describe Vagrancy::ProviderBox do


  let(:box) { double('Box') }
  let(:filestore) { double('Filestore') }
  let(:request) { double('Request') }
  let(:provider_box) { described_class.new('virtualbox', '1.2.1', box, filestore, request) }

  before do 
    allow(box).to receive(:path).and_return 'myuser/mybox'
    allow(request).to receive(:scheme).and_return 'http'
    allow(request).to receive(:host).and_return 'somesite'
    allow(request).to receive(:port).and_return 80
  end

  describe '#to_h' do
    it 'should return a hash-representation of the box if it exists' do
      allow(filestore).to receive(:exists?).with('myuser/mybox/1.2.1/virtualbox/box').and_return true

      expect(provider_box.to_h).to eql({:name=>"virtualbox", :url=>"http://somesite:80/myuser/mybox/1.2.1/virtualbox"})
    end
    it 'should an empty hash if the box does not exist' do
      allow(filestore).to receive(:exists?).with('myuser/mybox/1.2.1/virtualbox/box').and_return false

      expect(provider_box.to_h).to eql({})
      
    end
  end

  describe '#write' do
    it 'writes the box to the filestore' do
      expect(filestore).to receive(:write).with('myuser/mybox/1.2.1/virtualbox/box', 'data')

      provider_box.write 'data'
    end
  end

  describe '#read' do
    it 'returns the box data' do
      allow(filestore).to receive(:read).with('myuser/mybox/1.2.1/virtualbox/box').and_return 'box data'

      expect(provider_box.read).to eql 'box data'
    end
  end

  describe '#delete' do
    it 'deletes the box if it exists' do
      allow(filestore).to receive(:exists?).with('myuser/mybox/1.2.1/virtualbox/box').and_return true
      
      expect(filestore).to receive(:delete).with('myuser/mybox/1.2.1/virtualbox/box')

      provider_box.delete
    end
    it 'does not delete the box if it does not exist' do
      allow(filestore).to receive(:exists?).with('myuser/mybox/1.2.1/virtualbox/box').and_return false
      
      expect(filestore).to_not receive(:delete).with(anything)

      provider_box.delete
    end

  end

  describe '#exists?' do
    it 'is true if the box exists' do
      allow(filestore).to receive(:exists?).with('myuser/mybox/1.2.1/virtualbox/box').and_return true

      expect(provider_box.exists?).to be true
    end
    it 'is false if the box does not exist' do
      allow(filestore).to receive(:exists?).with('myuser/mybox/1.2.1/virtualbox/box').and_return false

      expect(provider_box.exists?).to be false
    end
    
  end

  describe '#url' do
    it 'returns the RESTful URL for this box' do
      expect(provider_box.url).to eql 'http://somesite:80/myuser/mybox/1.2.1/virtualbox'
    end
  end

end
