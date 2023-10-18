# frozen_string_literal: true

# BEGIN
require 'uri'
require 'forwardable'

class Url
  include Comparable
  extend Forwardable

  def_delegators :@uri, :scheme, :host, :port

  attr_reader :query_params

  def initialize(text)
    @uri = URI(text)
    @query_params = (@uri.query || '')
                    .split('&')
                    .sort
                    .to_h { |key_value_text| key_value_text.split('=') }
                    .transform_keys(&:to_sym)
  end

  def query_param(key, default_value = nil)
    query_params.fetch(key, default_value)
  end

  def <=>(other)
    [scheme, host, port, query_params] <=> [other.scheme, other.host, other.port, other.query_params]
  end
end
# END
