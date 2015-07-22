module Vagrancy
  class ProviderBox

    def initialize(provider, parent, filestore, request)
      @provider = provider
      @parent = parent
      @filestore = filestore
      @request = request
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
      @parent.path + '/' + @provider + '/box'
    end

  end
end
