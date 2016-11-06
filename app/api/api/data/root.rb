module API
  module Data
    class Root < Grape::API
      mount API::Data::General
    end
  end
end
