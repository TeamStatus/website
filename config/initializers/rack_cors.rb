require 'rack/cors'

ConsoleRails::Application.config.middleware.use Rack::Cors, :debug => false do
  allow do
    origins ENV['BOARDS_URL']

    resource '/*.json',
        :methods => [:get, :post, :put, :delete],
        :headers => :any,
        :max_age => 600,
        :credentials => true
  end
end