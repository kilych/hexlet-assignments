# frozen_string_literal: true

require 'rack'

class Router
  def call(env)
    # BEGIN
    request = Rack::Request.new(env)
    headers = { 'Content-Type' => 'text/html' }
    case request.path
    when '/'
      [200, headers, ['Hello, World!']]
    when '/about'
      [200, headers, ['About page']]
    else
      [404, headers, ['404 Not Found']]
    end
    # END
  end
end
