require 'spec_helper'

require 'vagrancy/atlas_box_adapter'

describe Vagrancy::AtlasBoxAdapter do
  
  let(:box) { double('Vagrancy::Box') }

  describe 'with valid data' do

    let(:json_data) { '{"artifact":{"username":"ryantest","name":"ubuntu1404"}}' }
    let(:adapter) { described_class.new(json_data) }

    it 'should return a box created with the correct username' do
      allow(Vagrancy::Box).to receive(:new).with('ryantest', anything).and_return(box)

      expect(adapter.box).to be(box)
    end

    it 'should return a box created with the correct name' do
      allow(Vagrancy::Box).to receive(:new).with(anything, 'ubuntu1404').and_return(box)

      expect(adapter.box).to be(box)
    end

  end

  describe 'with incomplete data'

  it 'should raise an error if there is no username' do
    adapter = described_class.new('{"artifact":{"username":"","name":"ubuntu1404"}}')

    expect{adapter.box}.to raise_error
  end

  it 'should raise an error if there is no name' do
    adapter = described_class.new('{"artifact":{"username":"ryantest","name":""}}')

    expect{adapter.box}.to raise_error
  end

end
