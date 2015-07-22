module Vagrancy
  class BoxVersion

    def initialize(version, parent, filestore, request)
      @version = version
      @parent = parent
      @filestore = filestore
      @request = request
    end

    def to_h
      { :version => @version, :providers => providers.collect { |p| p.to_h } } 
    end

    def path
      @parent.path + '/' + @version
    end

    def providers
      @filestore.directories_in(path).collect do |provider|
        puts provider
        ProviderBox.new(provider, self, @filestore, @request)
      end
    end

  end
end
