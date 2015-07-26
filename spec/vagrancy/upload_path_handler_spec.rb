require 'spec_helper'

require 'vagrancy/upload_path_handler'

describe Vagrancy::UploadPathHandler do

  let(:filestore) { double('Filestore') }
  let(:request) { double('SinatraRequest') }
  let(:handler) { described_class.new('mybox', 'myuser', request, filestore) }

  let(:message_body) { "{\"artifact_version\":{\"metadata\":{\"version\":\"1.0\",\"provider\":\"vbox\"}}}" }
  let(:box) { double('Box') }
  let(:provider_box) { double('ProviderBox') }

  describe '#to_json' do
    it 'returns the URL of where to upload the Vagrant box to' do
      allow(request).to receive_message_chain(:body, :read).and_return message_body
      allow(Vagrancy::Box).to receive(:new).with('mybox', 'myuser', filestore, request).and_return box
      allow(Vagrancy::ProviderBox).to receive(:new).with('vbox', '1.0', box, filestore, request).and_return provider_box
      allow(provider_box).to receive(:url).and_return 'http://some/location'

      expect(handler.to_json).to eql "{\"upload_path\":\"http://some/location\"}"
    end
  end

end

