require 'spec_helper'

require File.join(__FILE__, '..', '..', 'lib', 'roman_numerals')

describe RomanNumeralizer, type: :model do
  it("can convert 1 to I")       { expect(RomanNumeralizer.convert(1)   ).to eq 'I'    }
  it("can convert 2 to II")      { expect(RomanNumeralizer.convert(2)   ).to eq 'II'   }
  it("can convert 3 to III")     { expect(RomanNumeralizer.convert(3)   ).to eq 'III'  }
  it("can convert 4 to IV")      { expect(RomanNumeralizer.convert(4)   ).to eq 'IV'   }
  it("can convert 5 to V")       { expect(RomanNumeralizer.convert(5)   ).to eq 'V'    }
  it("can convert 6 to VI")      { expect(RomanNumeralizer.convert(6)   ).to eq 'VI'   }
  it("can convert 9 to IX")      { expect(RomanNumeralizer.convert(9)   ).to eq 'IX'   }
  it("can convert 10 to X")      { expect(RomanNumeralizer.convert(10)  ).to eq 'X'    }
  it("can convert 19 to XIX")    { expect(RomanNumeralizer.convert(19)  ).to eq 'XIX'  }
  it("can convert 30 to XXX")    { expect(RomanNumeralizer.convert(30)  ).to eq 'XXX'  }
  it("can convert 40 to XL")     { expect(RomanNumeralizer.convert(40)  ).to eq 'XL'   }
  it("can convert 44 to XLIV")   { expect(RomanNumeralizer.convert(44)  ).to eq 'XLIV' }
  it("can convert 50 to L")      { expect(RomanNumeralizer.convert(50)  ).to eq 'L'    }
  it("can convert 90 to XC")     { expect(RomanNumeralizer.convert(90)  ).to eq 'XC'   }
  it("can convert 100 to C")     { expect(RomanNumeralizer.convert(100) ).to eq 'C'    }
  it("can convert 101 to CI")    { expect(RomanNumeralizer.convert(101) ).to eq 'CI'   }
  it("can convert 190 to CXC")   { expect(RomanNumeralizer.convert(190) ).to eq 'CXC'  }
  it("can convert 400 to CD")    { expect(RomanNumeralizer.convert(400) ).to eq 'CD'   }
  it("can convert 500 to D")     { expect(RomanNumeralizer.convert(500) ).to eq 'D'    }
  it("can convert 600 to DC")    { expect(RomanNumeralizer.convert(600) ).to eq 'DC'   }
  it("can convert 990 to CMXC")  { expect(RomanNumeralizer.convert(990) ).to eq 'CMXC' }
  it("can convert 1000 to M")    { expect(RomanNumeralizer.convert(1000)).to eq 'M'    }
  it("can convert 2000 to MM")   { expect(RomanNumeralizer.convert(2000)).to eq 'MM'   }
  it("can convert 4000 to MMMM") { expect(RomanNumeralizer.convert(4000)).to eq 'MMMM' }

  it("can convert 4542 to MMMMDXLII") do
    expect(RomanNumeralizer.convert(4542)).to eq 'MMMMDXLII'
  end
end
