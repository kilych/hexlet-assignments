# frozen_string_literal: true

# BEGIN
require 'uri'
require 'forwardable'

class Url
  extend Forwardable

  include Comparable

  attr_reader :query_params

  def initialize(text)
    @uri = URI(text)
    @query_params =
      (@uri.query || '').split('&')
                        .sort
                        .to_h { |key_value_text| key_value_text.split('=') }
                        .transform_keys(&:to_sym)
  end

  def_delegators :@uri, :scheme, :host, :port

  def query_param(key, default_value = nil)
    query_params.key?(key) ? query_params[key] : default_value
  end

  def <=>(other)
    result = scheme <=> other.scheme
    return result unless result.zero?

    result = host <=> other.host
    return result unless result.zero?

    result = port <=> other.port
    return result unless result.zero?

    query_params <=> other.query_params
  end
end
# END
