module API
  class Root < Grape::API
    prefix 'api'
    mount API::Data::Root
  end
end
