class RomanNumeralizer
  I = { sym: 'I', val: 1 }.freeze
  V = { sym: 'V', val: 5 }.freeze
  X = { sym: 'X', val: 10 }.freeze
  L = { sym: 'L', val: 50 }.freeze
  C = { sym: 'C', val: 100 }.freeze
  D = { sym: 'D', val: 500 }.freeze
  M = { sym: 'M', val: 1000 }.freeze

  ALL = {
    single: {
      base_int: 1,
      ranges:   { 1..3 => I, 4..8 => V, 9..9 => X },
      prepend:  { all: I[:sym] },
      append:   { all: I[:sym] }
    },

    tens: {
      base_int: 10,
      ranges:   { 1..3 => X, 4..8 => L, 9..9 => C },
      prepend:  { all: X[:sym] },
      append:   { all: X[:sym] }
    },

    hundreds: {
      base_int: 100,
      ranges:   { 1..3 => C, 4..8 => D, 9..9 => M },
      prepend:  { 1..3 => X[:sym], 4..9 => C[:sym] },
      append:   { 1..3 => X[:sym], 4..9 => C[:sym] }
    },

    thousands: {
      base_int: 1000,
      ranges:   { 1..4 => M },
      prepend:  { 1..4 => '' },
      append:   { 1..4 => M[:sym] }
    },

    # Need to figure out nice way of implementing displaying exponents for the tens_ + hundreds_ of K's
    tens_of_thousands: {
      base_int: 10_000,
      ranges:   {},
      prepend:  {},
      append:   {}
    },

    hundreds_of_thousands: {
      base_int: 100_000,
      ranges:   {},
      prepend:  {},
      append:   {}
    }
  }.freeze

  BASE_NAMES = [:single, :tens, :hundreds, :thousands, :tens_of_thousands, :hundreds_of_thousands].freeze

  class << self
    def convert(num)
      new(num).convert
    end
  end

  attr_accessor :num, :chars, :name_to_char_map

  def initialize(num)
    self.num              = num
    self.chars            = num.to_s.split('').map(&:to_i)
    self.name_to_char_map = Hash.new(0)
    build_name_to_char_map
  end

  def convert
    BASE_NAMES.reverse.map { |name| Converter.new(name_to_char_map[name], ALL[name]).resolve }.join
  end

  private

  def build_name_to_char_map
    chars.reverse.each_with_index { |char, i| name_to_char_map[BASE_NAMES[i]] = char }
  end

  class Converter
    attr_accessor :start_number, :base_int, :ranges, :prepend_opts, :append_opts, :number, :base_numeral

    RANGED_EXTRACTOR = -> (tuples, num) do
      appropriate_tuple = Array(tuples).detect { |(rng, val)| rng.include?(num) }
      appropriate_tuple.last if appropriate_tuple
    end

    def initialize(num, params)
      self.base_int,     self.ranges      = params[:base_int], params[:ranges]
      self.prepend_opts, self.append_opts = params[:prepend],  params[:append]
      self.start_number, self.number      = num,               num * base_int

      self.base_numeral = RANGED_EXTRACTOR.call(ranges, start_number)
    end

    def resolve
      return ''               if number.zero?
      return base_numeral_sym if diff.zero?
      return with_prepend     if diff_lower_than_zero?
      return with_append      if diff_greater_than_zero?
    end

    private

    def with_append
      base_numeral_sym + (sym_to_append * (diff / base_int))
    end

    def with_prepend
      sym_to_prepend + base_numeral_sym
    end

    def sym_to_append;  get_sym(append_opts)  end
    def sym_to_prepend; get_sym(prepend_opts) end

    def get_sym(opts)
      opts[:all] ? opts[:all] : extract_sym_from(opts)
    end

    def base_numeral_sym; base_numeral[:sym] end
    def base_numeral_val; base_numeral[:val] end

    def diff; number - base_numeral_val end

    def diff_lower_than_zero?;   diff < 0 end
    def diff_greater_than_zero?; diff > 0 end

    def extract_sym_from(opts)
      RANGED_EXTRACTOR.call(opts, start_number)
    end
  end
end
