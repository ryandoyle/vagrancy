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
      @filestore.write(file_path, stream)
    end

    def read
      @filestore.read(file_path)
    end

    def delete
      @filestore.delete(file_path) if exists?
    end

    def exists?
      @filestore.exists?(file_path)
    end

    def url
      base_site + '/' + path 
    end

    private 

    def base_site
      @request.scheme + '://' + @request.host + ':' + @request.port.to_s
    end

    def file_path
      path + '/box'
    end

    def path
      @box.path + '/' + @version + '/' + @provider
    end

  end
end
