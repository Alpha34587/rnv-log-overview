require 'test/unit'
require 'xlo'

class TestXmllintWrapper < Test::Unit::TestCase
  attr_accessor :xlo, :expected

  def setup
    @xlo = Xlo.new
    @expected = "test/resources/xml/1.xml:69: validity error : xml:id : attribute value 12 is not an NCName \t\t\t\t\t\t\t<term xml:id=\"12\">tdainooxi</term> \t\t\t\t\t\t\t                 ^ test/resources/xml/1.xml:72: validity error : xml:id : attribute value 12 is not an NCName \t\t\t\t\t\t\t<term xml:id=\"12\">kcentiis</term> \t\t\t\t\t\t\t                 ^ test/resources/xml/1.xml:72: element term: validity error : ID 12 already defined \t\t\t\t\t\t\t<term xml:id=\"12\">kcentiis</term> \t\t\t\t\t\t\t                 ^"
  end

  def test_return_value
    observed =  @xlo.xmllint_wrapper("test/resources/xml/1.xml").join(" ")
    assert_equal(@expected, observed, 'Assertion was false.')
  end
end
