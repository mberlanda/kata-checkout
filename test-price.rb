require 'test-unit'

class CheckOut

  def initialize(rules)
    @tot = 0
    @item_hash = {}
  end

  def scan(item)
    if @item_hash[item]
      @item_hash[item] += 1
    else
      @item_hash[item] = 1
    end

  end

  def total
    if @item_hash["A"]
      @tot += 50 * @item_hash["A"]
    end
    if @item_hash["B"]
      @tot += 30 * @item_hash["A"]
    end
    @tot

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
    assert_equal( 80, price("AB"))

  end

end

