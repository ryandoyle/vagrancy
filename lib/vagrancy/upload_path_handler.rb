require 'json'
module Vagrancy
  class UploadPathHandler
    def initialize(name, username, request)
      @name = name
      @username = username
      @request = request
    end

    def to_json
      { :upload_path => base_site + upload_url }.to_json
    end

    private

    def base_site
      @request.scheme + '://' + @request.host + ':' + @request.port.to_s
    end

    def upload_url
      '/' + @username + '/' + @name  + '/' + version + '/' + provider + '/box'
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
