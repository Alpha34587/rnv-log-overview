require 'test/unit'
require 'xlo'

class TestXmllintAggregate < Test::Unit::TestCase
  attr_accessor :xlo, :expected

  def setup
    @xlo = Xlo.new
    @expected = {"attribute; attribute value 12 is not an NCName"=>"1.xml:69 || 1.xml:72",
 "element; ID 12 already defined"=>"1.xml:72"}
  end
  def test_return_value
    @xlo.xmllint_aggregate(@xlo.xmllint_wrapper("test/resources/xml/1.xml")).join(" ")
    assert_equal(@expected, @xlo.get_error, 'Assertion was false.')
  end
end
