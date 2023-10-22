# frozen_string_literal: true

# BEGIN
require 'date'

module Model
  def initialize(attrs = {})
    attr_opts = self.class.attribute_options
    attrs.slice(*attr_opts.keys).each do |attr, val|
      options = attr_opts[attr]

      val = self.class.convert_to(val, options[:type]) if options.key?(:type)

      instance_variable_set "@#{attr}", val
    end
  end

  def attributes
    self.class
        .attribute_options
        .keys
        .each_with_object({}) do |attr_name, attrs|
          attrs[attr_name] = send attr_name
        end
  end

  module ClassMethods
    def attribute_options
      @attribute_options || {}
    end

    def attribute(name, **options)
      @attribute_options ||= {}
      @attribute_options[name] = options

      define_method name do
        if instance_variable_defined? "@#{name}"
          instance_variable_get "@#{name}"
        else
          options[:default]
        end
      end

      define_method "#{name}=" do |val|
        val = self.class.convert_to(val, options[:type]) if options.key?(:type)
        instance_variable_set "@#{name}", val
      end
    end

    def convert_to(val, type)
      if !val.nil? && type == :datetime
        DateTime.parse(val)
      else
        # Kernel.const_get(type.to_s.capitalize).new(val)

        conversion_method = "to_#{type}"
        if val.respond_to?(conversion_method)
          val.send(conversion_method)
        else
          val
        end
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
# END
