require 'spec_helper'

require 'vagrancy/box'

describe Vagrancy::Box do

  let(:name) { "boxname" }
  let(:group) { "boxgroup" }
  let(:filestore) { double('filestore') }
  let(:description) { 'my description' }
  let(:short_description) { 'short desc' }
  let(:box) { described_class.new(name,group,filestore, :description => description, :short_description => short_description)  }

  describe '#save' do
    it 'writes to the filestore if the box does not already exist' do
      allow(filestore).to receive(:exists?).and_return false
      expect(filestore).to receive(:write).with('boxgroup/boxname.json', '{"description":"my description","short_description":"short desc","name":"boxgroup/boxname","versions":[]}')

      box.save
    end
    it 'raises an error if saving and the box already exists' do
      allow(filestore).to receive(:exists?).and_return true

      expect{box.save}.to raise_error
    end
  end

  describe '#update' do
    it 'saves over the top of the current box' do
      expect(filestore).to receive(:write).with('boxgroup/boxname.json', '{"description":"my description","short_description":"short desc","name":"boxgroup/boxname","versions":[]}')

      box.update
    end
  end

end
