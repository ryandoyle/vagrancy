module Vagrancy; module Helpers
  module ParamSanitizer

    def sanitised_param(name)
      param = params[name]
      raise InvalidParameterName.new "invalid parameter #{param}" unless /^[0-9a-zA-Z_\-]+$/ =~ param
      param
    end

  end

  class InvalidParameterName < StandardError; end
end; end