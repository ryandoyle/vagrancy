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

    def exists?
      providers.any? { |p| p.exists? }
    end

    private 

    def path
      @parent.path + '/' + @version
    end

    def providers
      @providers ||= @filestore.directories_in(path).collect do |provider|
        ProviderBox.new(provider, @version, @parent, @filestore, @request)
      end
    end

  end
end
