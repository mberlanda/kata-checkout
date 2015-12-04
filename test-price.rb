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
      @tot += 130 * (@item_hash["A"]/3)
      @tot += 50 * (@item_hash["A"]%3)
    end
    if @item_hash["B"]
      @tot += 30 * @item_hash["B"]
    end
    if @item_hash["C"]
      @tot += 20 * @item_hash["C"]
    end
    if @item_hash["D"]
      @tot += 15 * @item_hash["D"]
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
    assert_equal(115, price("CDBA"))

    assert_equal(100, price("AA"))
    assert_equal(130, price("AAA"))
    assert_equal(180, price("AAAA"))
    assert_equal(230, price("AAAAA"))
    assert_equal(260, price("AAAAAA"))

  end

end

