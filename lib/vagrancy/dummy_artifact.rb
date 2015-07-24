require 'json'

module Vagrancy
  class DummyArtifact

    def initialize(parameters)
      @parameters = parameters
    end

    def to_json
      { :artifact => { :username => @parameters[:username], :name => @parameters[:name]  } }.to_json
    end

  end
end
