require 'spec_helper'

require 'vagrancy/box'

describe Vagrancy::Box do

  let(:name) { "boxname" }
  let(:group) { "boxgroup" }
  let(:filestore) { double('Filestore') }
  let(:request) { double('SinatraRequest') }
  let(:box) { described_class.new(name,group,filestore,request)  }


  describe '#exists?' do
    it 'is true if the box exists' do
      allow(filestore).to receive(:exists?).with('boxgroup/boxname').and_return true

      expect(box.exists?).to be true
    end
    it 'is false if it does not exist' do
      allow(filestore).to receive(:exists?).with('boxgroup/boxname').and_return false

      expect(box.exists?).to be false
    end
  end

  describe '#to_json' do

    let(:box_versions) { double('BoxVersions', :to_a => ['1', '2']) }

    it 'returns a json representation of the box' do
      allow(Vagrancy::BoxVersions).to receive(:new).with(box, filestore, request).and_return box_versions

      expect(box.to_json).to eql "{\"name\":\"boxgroup/boxname\",\"versions\":[\"1\",\"2\"]}"
    end
  end

end
