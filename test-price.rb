require 'test-unit'

class CheckOut

  def initialize(rules)
  #
  end

  def scan(item)
    @item = item
  end

  def total
    case @item
    when "A"
      50
    else
      0
    end

  end

end

RULES = {}

class TestPrice < Test::Unit::TestCase

  def price(goods)
    co = CheckOut.new(RULES)
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  def test_totals
    assert_equal(  0, price(""))
    assert_equal( 50, price("A"))
  end

end

