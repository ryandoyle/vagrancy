require 'spec_helper'

require 'vagrancy/json_box_adapter'

describe Vagrancy::JSONBoxAdapter do

  let(:name)    { "mybox" }
  let(:group)   { "mygroup" }
  let(:json_string) { '{
    "description": "Box_description",
    "short_description": "This is my Vagrant box."
    }'
  }
  let(:filestore) { double('filestore') }
  let(:adapter) { Vagrancy::JSONBoxAdapter.new(name, group, json_string, filestore) }
  let(:box) { double('box') }

  describe '#new_box' do
    before do
      allow(Vagrancy::Box).to receive(:new).and_return(box) 
    end

    it 'creates a new Vagrancy::Box with the correct name' do
      expect(Vagrancy::Box).to receive(:new).with("mybox", any_args).and_return(box)

      adapter.new_box
    end
    it 'creates a new Vagrancy::Box with the correct group' do
      expect(Vagrancy::Box).to receive(:new).with(anything, "mygroup", any_args).and_return(box)

      adapter.new_box
    end
    it 'creates a new Vagrancy::Box with a filestore' do
      expect(Vagrancy::Box).to receive(:new).with(anything, anything, filestore, anything).and_return(box)

      adapter.new_box
    end
    it 'creates a new Vagrancy::Box with a description' do
      expect(Vagrancy::Box).to receive(:new).with(anything, anything, anything, :description => 'Box_description', :short_description => anything).and_return(box)

      adapter.new_box
    end
    it 'creates a new Vagrancy::Box with a short_description' do
      expect(Vagrancy::Box).to receive(:new).with(anything, anything, anything, :description => anything, :short_description => 'This is my Vagrant box.').and_return(box)

      adapter.new_box
    end


    describe 'invalid json data' do
      let (:json_string) { "invalid" }
      it 'raises an error ' do
        expect{adapter.new_box}.to raise_error
      end
    end

    describe 'when no description is set in the payload' do
      let(:json_string) { '{
        "short_description": "This is my Vagrant box."
        }'
      }
      it 'should raise an error' do
        expect{adapter.new_box}.to raise_error(ArgumentError, 'description not set')
      end
    end

    describe 'when no short description is set in the payload' do
      let(:json_string) { '{
        "description": "This is my Vagrant box."
        }'
      }
      it 'should raise an error' do
        expect{adapter.new_box}.to raise_error(ArgumentError, 'short_description not set')
      end
    end

  end
end
