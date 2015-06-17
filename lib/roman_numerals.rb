class RomanNumeralizer
  UNITS = [:single, :tens, :hundreds, :thousands, :tens_of_thousands, :hundreds_of_thousands]

  I = { sym: 'I', val: 1 }
  V = { sym: 'V', val: 5 }
  X = { sym: 'X', val: 10 }
  L = { sym: 'L', val: 50 }
  C = { sym: 'C', val: 100 }
  D = { sym: 'D', val: 500 }
  M = { sym: 'M', val: 1000 }


  class << self
    def convert(num)
      new(num).convert
    end

    def define_unit_methods!
      UNITS.each do |unit|
        klass     = Kernel.const_get("RomanNumeralizer::" + unit.to_s.gsub(/\A.|_./) { |m| m[-1].upcase! })
        ivar_name = :"@#{unit}"
        bool_name = :"#{unit}?"

        define_method(unit) do
          instance_variable_get(ivar_name) || instance_variable_set(ivar_name, klass.new(units[unit]))
        end

        define_method(bool_name) { !!public_send(unit) }
      end
    end
  end

  attr_accessor :num, :chars, :units

  def initialize(num)
    self.num   = num
    self.chars = num.to_s.split('').map(&:to_i)
    self.units = Hash.new(0)
    process_units
  end

  def convert
    UNITS.reverse.map { |unit| (inst = public_send(unit)) && inst.resolve }.compact.join
  end

  private

  def process_units
    chars.reverse.each_with_index { |char, i| units[UNITS[i]] = char }
  end

  module Rangeable
    attr_accessor :start_num, :num, :base

    def initialize(num)
      return if num.zero?
      self.start_num = num
      self.num       = num * self.class::BASE
      self.base      = find_base
    end

    def resolve
      return unless num
      return base_sym if diff.zero?
      return prepend  if diff_lower_than_zero?
      return append   if diff_greater_than_zero?
    end

    private

    def append
      base_sym + (append_sym * (diff / self.class::BASE))
    end

    def append_sym
      append_const = self.class::APPEND
      return append_const[:all] if append_const[:all]

      extract_from(append_const.to_a)
    end

    def prepend
      prepend_sym + base_sym
    end

    def prepend_sym
      prepend_const = self.class::PREPEND
      return prepend_const[:all] if prepend_const[:all]

      extract_from(prepend_const.to_a)
    end

    def base_sym; base[:sym] end

    def base_val; base[:val] end

    def diff; num - base_val end

    def diff_lower_than_zero?;   diff < 0 end

    def diff_greater_than_zero?; diff > 0 end

    def extract_from(collection)
      collection.detect { |(rng, val)| rng.include?(start_num) }.last
    end

    def find_base
      extract_from(self.class::RANGES)
    end
  end

  class Single
    include Rangeable

    BASE    = 1
    RANGES  = [[1..3, I], [4..8, V], [9..9, X]]
    PREPEND = { all: I[:sym] }
    APPEND  = { all: I[:sym] }
  end

  class Tens
    include Rangeable

    BASE    = 10
    RANGES  = [[1..3, X], [4..8, L], [9..9, C]]
    PREPEND = { all: X[:sym] }
    APPEND  = { all: X[:sym] }
  end

  class Hundreds
    include Rangeable

    BASE    = 100
    RANGES  = [[1..3, C], [4..8, D], [9..9, M]]
    PREPEND = { 1..3 => X[:sym], 4..9 => C[:sym] }
    APPEND  = { 1..3 => X[:sym], 4..9 => C[:sym] }
  end

  class Thousands
    include Rangeable

    BASE    = 1000
    RANGES  = [[1..4, M]]
    PREPEND = { 1..4 => '' }
    APPEND  = { 1..4 => 'M' }
  end

  class TensOfThousands
    include Rangeable

    BASE    = 10_000
    RANGES  = []
    PREPEND = {}
    APPEND  = {}
  end

  class HundredsOfThousands
    include Rangeable

    BASE    = 100_000
    RANGES  = []
    PREPEND = {}
    APPEND  = {}
  end
end

RomanNumeralizer.define_unit_methods!
