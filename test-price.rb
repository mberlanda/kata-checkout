require 'test-unit'

class ItemPrice

  def initialize(price_sgl, bool_offer=false, no_offer=1, price_offer=price_sgl)
    @price_sgl = price_sgl
    @has_offer = bool_offer
    @no_offer = no_offer
    @price_offer = price_offer
  end

  attr_reader :price_sgl, :has_offer, :no_offer, :price_offer

end  

RULES = {
  "" => ItemPrice.new(0, false),
  "A" => ItemPrice.new(50, true, 3, 130),
  "B" => ItemPrice.new(30, true, 2, 45),
  "C" => ItemPrice.new(20, false),
  "D" => ItemPrice.new(15, false)
}

class ItemListException < StandardError; end

class CheckOut

  def initialize(rules)
    @item_list = rules
    @item_shopped = {}
  end

  def scan(item)

    begin
    rescue ItemListException
      puts "#{item} is not available"
    end  

    raise ItemListException unless @item_list.keys.include? item
    
    if @item_shopped[item]
      @item_shopped[item] += 1
    else
      @item_shopped[item] = 1
    end

  end

  def total
    tot = 0

    @item_shopped.keys.each do |i|
      art = @item_list[i]
      if art.has_offer
        tot += art.price_offer * (@item_shopped[i]/art.no_offer)
        tot += art.price_sgl * (@item_shopped[i]%art.no_offer)
      else
        tot += art.price_sgl * @item_shopped[i]
      end
    end

    tot

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

