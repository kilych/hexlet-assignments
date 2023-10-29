# frozen_string_literal: true

require 'digest'

class Signature
  def initialize(app)
    @app = app
  end

  def call(env)
    # BEGIN
    status, headers, body = @app.call(env)
    body << "\n" << Digest::SHA2.new(256).hexdigest(body.first)
    [status, headers, body]
    # END
  end
end
