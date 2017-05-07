module Vagrancy; module Plugin
  class ContentServer

    def serve
      raise NotImplementedError.new
    end

    def verb
      self.class.verb || :get
    end

    def path
      self.class.path
    end

    protected

    def self.path(location = nil)
      location && (@location = location)
      @location
    end

    def self.verb(verb = nil)
      verb && (@verb = verb)
      @verb
    end

  end
end; end