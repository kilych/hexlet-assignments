# frozen_string_literal: true

# BEGIN
require 'date'

module Model
  def self.included(base)
    base.extend(ClassMethods)
    base.class_variable_set '@@attrs', {}
  end

  def initialize(attrs_to_vals = {})
    attrs = self.class.class_variable_get '@@attrs'
    attrs_to_vals.slice(*attrs.keys).each do |attr, val|
      options = attrs[attr]

      val = convert_to(val, options[:type]) if options.key?(:type)

      instance_variable_set "@#{attr}", val
    end
  end

  def attributes
    self.class
        .class_variable_get('@@attrs')
        .keys
        .each_with_object({}) do |attr_name, attrs|
          attrs[attr_name] = send attr_name
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

  module ClassMethods
    def attribute(name, **options)
      old_attrs = class_variable_get('@@attrs')
      new_attrs = old_attrs.merge({ name => options })
      class_variable_set '@@attrs', new_attrs

      define_method name do
        if instance_variable_defined? "@#{name}"
          instance_variable_get "@#{name}"
        else
          options[:default]
        end
      end

      define_method "#{name}=" do |val|
        val = convert_to(val, options[:type]) if options.key?(:type)
        instance_variable_set "@#{name}", val
      end
    end
  end
end
# END
