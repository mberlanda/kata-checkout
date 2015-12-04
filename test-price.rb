require 'test-unit'

class CheckOut

  def initialize(rules)
  #
  end

  def total
  0
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
  end

end

