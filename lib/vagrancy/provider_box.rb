module Vagrancy
  class ProviderBox

    def initialize(provider, version, box, filestore, request)
      @provider = provider
      @box = box
      @filestore = filestore
      @request = request
      @version = version
    end

    def to_h
      exists? ? {:name => @provider, :url => url} : {}
    end

    def write(stream)
      @filestore.write(path, stream)
    end

    def read
      @filestore.read(path)
    end

    def exists?
      @filestore.exists?(path)
    end

    def url
      base_site + '/' + path 
    end

    def base_site
      @request.scheme + '://' + @request.host + ':' + @request.port.to_s
    end

    def path
      @box.path + '/' + @version + '/' + @provider + '/box'
    end

  end
end
