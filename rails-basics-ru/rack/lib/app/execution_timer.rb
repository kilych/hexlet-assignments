# frozen_string_literal: true

class ExecutionTimer
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    status, headers, body = @app.call(env)

    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = finish - start
    body << "\n#{elapsed} seconds"

    [status, headers, body]
  end
end
