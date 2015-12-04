require 'test-unit'

class ItemPrice

  def initialize(price_unit: , min_item: 1, price_offer: price_unit)
    @price_unit = price_unit
    @min_item = min_item
    @price_offer = price_offer
  end

  def price_per_quantity(units)
    
    units_offer = units / @min_item
    units_excl_offer = units % @min_item
    @price_offer * units_offer + @price_unit * units_excl_offer

  end

end  

RULES = {
  "" => ItemPrice.new(price_unit: 0),
  "A" => ItemPrice.new(price_unit: 50, min_item: 3, price_offer: 130),
  "B" => ItemPrice.new(price_unit: 30, min_item: 2, price_offer: 45),
  "C" => ItemPrice.new(price_unit: 20),
  "D" => ItemPrice.new(price_unit: 15)
}

class CheckOut

  def initialize(price_list)
    @items_list = price_list
    @items_shopped = {}
  end

  def scan(item)

    raise "#{item} is not available" unless @items_list.keys.include? item
    @items_shopped[item] ||= 0
    @items_shopped[item] += 1

  end

  def total
    subtotal = 0

    @items_shopped.keys.each do |i|
      
      good, units = @items_list[i], @items_shopped[i]
      subtotal += good.price_per_quantity(units)

    end

    subtotal

  end
end


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

    assert_equal(160, price("AAAB"))
    assert_equal(175, price("AAABB"))
    assert_equal(190, price("AAABBD"))
    assert_equal(190, price("DABABA"))

  end

  def test_incremental
    co = CheckOut.new(RULES)
    assert_equal(  0, co.total)
    co.scan("A");  assert_equal( 50, co.total)
    co.scan("B");  assert_equal( 80, co.total)
    co.scan("A");  assert_equal(130, co.total)
    co.scan("A");  assert_equal(160, co.total)
    co.scan("B");  assert_equal(175, co.total)
  end

end