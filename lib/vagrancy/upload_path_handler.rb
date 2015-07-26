require 'json'

require 'vagrancy/box'
require 'vagrancy/provider_box'

module Vagrancy
  class UploadPathHandler
    def initialize(name, username, request, filestore)
      @name = name
      @username = username
      @request = request
      @filestore = filestore
    end

    def to_json
      { :upload_path => upload_path }.to_json
    end

    private

    def upload_path 
      box = Box.new(@name, @username, @filestore, @request)
      ProviderBox.new(provider, version, box, @filestore, @request).url
    end

    def version
      json['artifact_version']['metadata']['version']
    end

    def provider
      json['artifact_version']['metadata']['provider']
    end

    def json
      @json ||= JSON.parse @request.body.read
    end

  end
end
