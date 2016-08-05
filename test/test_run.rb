require 'test/unit'
require '../lib/xlo'

class TestRun < Test::Unit::TestCase
  attr_accessor :xlo_only, :xlo_multi

  def setup
    @xlo_only = Xlo.new
    @xlo_multi = Xlo.new
    @xlo_only.run("resources/schema/tei-all.rnc","resources/xml",1)
    @xlo_multi.run("resources/schema/tei-all.rnc","resources/xml",4)
  end

  def test_keys
    assert_equal(@xlo_only.get_error.keys.sort,@xlo_multi.get_error.keys.sort, 'Assertion was false.')
  end

  def test_values
    list_only = []
    list_multi = []
    @xlo_only.get_error.values.each { |x|  list_only << x.split(/\|\|/).each { |el| el.strip! } }
    @xlo_multi.get_error.values.each { |x|  list_multi << x.split(/\|\|/).each { |el| el.strip! } }
      assert_equal(list_only.flatten.sort, list_multi.flatten.sort, 'Assertion was false.')
  end
end
