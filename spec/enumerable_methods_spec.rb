# frozen_string_literal: true

require_relative '../enumerable.rb'

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 6, 7] }
  let(:names) { %w[elijah obominuru dev] }
  let(:operator) { proc { |x| x + 1 } }

  describe '#my_each' do
    it 'returns the array itself' do
      default_arr = []
      tested_arr = []

      array.each { |x| default_arr << x + 1 }
      array.my_each { |x| tested_arr << x + 1 }
      expect(tested_arr).to eql(default_arr)
    end

    context 'when a block is not given'
    it 'returns an Enumerator when no block given' do
      expect(array.my_each.is_a?(Enumerator)).to be(true)
    end

    it 'returns the default array when the output is not there' do
      expect(array.my_each { operator }).to eq(array)
    end
  end

  describe '#my_each_with_index' do
    it 'the item and its index is returned' do
      default_arr = []
      tested_arr = []

      array.each_with_index { |x, y| tested_arr << [x, y] }
      array.my_each_with_index { |x, y| default_arr << [x, y] }
      expect(tested_arr).to eql(default_arr)
    end

    context 'when a block is not given'
    it 'returns an Enumerator when no block given' do
      expect(array.my_each_with_index.is_a?(Enumerator)).to be(true)
    end

    context 'when a block is not given'
    it 'returns an Enumerator when no block given' do
      expect(names.my_each_with_index.is_a?(Enumerator)).to be(true)
    end

    it 'returns the default array when the output is not there' do
      expect(array.my_each_with_index { operator }).to eq(0...7)
    end
  end

  describe '#my_select' do
    it 'select elements by given specific condition' do
      default_arr = array.select { |x| x < 2 }
      tested_arr = array.my_select { |x| x < 2 }
      expect(tested_arr).to eql(default_arr)
    end
  end

  describe '#my_all?' do
    it 'returns true if all elements are true (or empty array)' do
      default = array.all? { |x| x > 0 }
      tested = array.my_all? { |x| x > 0 }
      expect(tested).to eql(default)
    end

    context 'Argument = Class'
    it 'returns true when all elements belong to the class passed as argument or false when it does not pass' do
      expect(array.my_all?(Integer)).to eql(true)
      expect(array.my_all?(String)).to eql(false)
    end

    context 'Argument = Regexp'
    it 'returns true when all elements match the Regular Expression passed or false when it does not pass' do
      expect(names.my_all?(/[a-z]/)).to eql(true)
      expect(names.my_all?(/d/)).to eql(false)
    end
  end

  describe '#my_any?' do
    it 'returns true if at least one element is true (or non empty array) or false when it does not pass.' do
      default = array.any? { |x| x > 3 }
      tested = array.my_any? { |x| x > 3 }
      expect(tested).to eql(default)
    end

    context 'Argument = Class'
    it 'returns true when all elements belong to the class passed as argument or false when it does not pass' do
      expect(array.my_any?(Integer)).to eql(true)
      expect(array.my_any?(String)).to eql(false)
    end

    context 'Argument = Regexp'
    it 'returns true when all elements match the Regular Expression passed or false when it does not pass' do
      expect(names.my_any?(/[a-z]/)).to eql(true)
      expect(names.my_any?(/z/)).to eql(false)
    end
  end

  describe '#my_none?' do
    it 'returns true if no elements are true (or empty array).' do
      default = array.none? { |x| x == 8 }
      tested = array.my_none? { |x| x == 8 }
      expect(tested).to eql(default)
    end

    context 'Argument = Class'
    it 'returns true when all elements belong to the class passed as argument or false when it does not pass' do
      expect(array.my_none?(Integer)).to eql(false)
      expect(array.my_none?(String)).to eql(true)
    end

    context 'Argument = Regexp'
    it 'returns true when all elements match the Regular Expression passed or false when it does not pass' do
      expect(names.my_none?(/[a-z]/)).to eql(false)
      expect(names.my_none?(/z/)).to eql(true)
    end
  end

  describe '#my_count' do
    it 'takes an enumerable collection and counts how many elements match the given criteria.' do
      default = array.count { |x| x > 5 }
      tested = array.my_count { |x| x > 5 }
      expect(tested).to eql(default)
    end

    it 'returns array length when no block given' do
      expect(array.my_count).to eq(7)
    end

    it 'returns the number of elements that is equal to the given argument' do
      expect(array.my_count(2)).to eq(1)
    end

    it 'returns the number of elements that match with a given condition' do
      expect(array.my_count(&:odd?)).to eq(4)
    end
  end

  describe '#my_map' do
    it 'returns a new array with the results of running block.' do
      default_arr = array.map { |x| x * x }
      tested_arr = array.my_map { |x| x * x }
      expect(tested_arr).to eql(default_arr)
    end

    it 'returns a modified array resulting from block operation' do
      expect(array.my_map(&operator)).to eq([2, 3, 4, 5, 6, 7, 8])
    end

    it 'returns modified array when given a range with a block' do
      expect(array.my_map(&operator)).to eq([2, 3, 4, 5, 6, 7, 8])
    end

    it 'returns array of strings when given array of integers' do
      expect(array.my_map(&:to_s)).to eq(%w[1 2 3 4 5 6 7])
    end
  end

  describe '#my_inject' do
    it 'combines all elements of enum by applying a binary operation' do
      default_arr = array.inject { |x, y| x + y }
      tested_arr = array.my_inject { |x, y| x + y }
      expect(tested_arr).to eql(default_arr)
    end

    it 'returns the name if it is greater than the name of its left side' do
      expect(names.my_inject { |x, name| x.length > name.length ? x : name }).to eq 'obominuru'
    end

    it 'returns the sum of the elements plus 5' do
      expect(array.my_inject(5) { |sum, x| sum + x }).to eq(33)
    end
  end

  describe '#multiply_els' do
    it 'return the product of all the elements of an array' do
      result = multiply_els(array)
      expect(result).to eql(5040)
    end
  end
end
