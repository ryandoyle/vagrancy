require 'sinatra/base'

module Vagrancy
  class App < Sinatra::Base
    set :logging, true

    get '/:groupname/:boxname' do
      "return box info"
    end

  end
end
