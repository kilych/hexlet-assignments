# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/stack'

class StackTest < Minitest::Test
  # BEGIN
  def setup
    @stack = Stack.new
    @stack.push! 'ruby'
    @stack.push! 'php'
    @stack.push! 'java'
  end

  def test_push_new_item
    @stack.push! 'scheme'
    expected = ['ruby', 'php', 'java', 'scheme']
    given = @stack.to_a
    assert_equal expected, given
  end

    def test_pop
      @stack.pop!
      expected = ['ruby', 'php']
      given = @stack.to_a
      assert_equal expected, given
    end

    def test_check_empiness
      stack = Stack.new
      assert stack.empty?
    end

    def test_clear
      @stack.clear!
      assert @stack.empty?
    end
  # END
end

test_methods = StackTest.new({}).methods.select { |method| method.start_with? 'test_' }
raise 'StackTest has not tests!' if test_methods.empty?
