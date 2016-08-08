require 'test/unit'
require 'xlo'

class TestRnvAggregate < Test::Unit::TestCase
  attr_accessor :xlo, :expected

    def setup
      @xlo = Xlo.new
      @expected = {"attribute; id with invalid value \"12\""=>"1.xml:69:7  || 1.xml:72:7 ",
        "attribute; type not allowed"=>
        "1.xml:56:7  || 1.xml:57:7  || 1.xml:66:4  || 1.xml:332:8  || 1.xml:333:8  || 1.xml:376:8  || 1.xml:399:8  || 1.xml:422:8  || 1.xml:423:8  || 1.xml:446:8  || 1.xml:447:8  || 1.xml:465:8  || 1.xml:466:8  || 1.xml:496:8  || 1.xml:497:8  || 1.xml:528:8  || 1.xml:529:8  || 1.xml:559:8  || 1.xml:560:8  || 1.xml:584:8  || 1.xml:585:8  || 1.xml:609:8  || 1.xml:610:8  || 1.xml:627:8  || 1.xml:628:8  || 1.xml:647:8  || 1.xml:671:8  || 1.xml:704:8  || 1.xml:725:8  || 1.xml:726:8  || 1.xml:826:8  || 1.xml:827:8  || 1.xml:866:8  || 1.xml:867:8  || 1.xml:891:8  || 1.xml:892:8  || 1.xml:921:8  || 1.xml:922:8  || 1.xml:940:8  || 1.xml:941:8  || 1.xml:982:8  || 1.xml:1047:8  || 1.xml:1048:8  || 1.xml:1094:8  || 1.xml:1095:8  || 1.xml:1111:8  || 1.xml:1112:8  || 1.xml:1140:8  || 1.xml:1141:8  || 1.xml:1170:8  || 1.xml:1171:8  || 1.xml:1217:8  || 1.xml:1218:8  || 1.xml:1248:8  || 1.xml:1283:8  || 1.xml:1333:8  || 1.xml:1361:8  || 1.xml:1381:8  || 1.xml:1382:8  || 1.xml:1422:8 ",
        "element; publicationStt not allowed"=>"1.xml:8:3 ",
        "element; surnae not allowed"=>"1.xml:24:8 ",
        "other;  incomplete content"=>"1.xml:12:3  || 1.xml:373:7  || 1.xml:773:7 ",
        "other;  invalid data or text not allowed"=>
        "1.xml:395:32  || 1.xml:700:31  || 1.xml:978:31  || 1.xml:997:22  || 1.xml:1016:22  || 1.xml:1329:31  || 1.xml:1357:31  || 1.xml:1377:22  || 1.xml:1418:31 ",
        "other;  unfinished content of element http://www.tei-c.org/ns/1.0^monogr"=>
        "1.xml:350:6  || 1.xml:757:6  || 1.xml:858:6 "}
    end

    def test_return_value
      @xlo.rnv_aggregate(@xlo.rnv_wrapper("test/resources/schema/tei-all.rnc",
      "test/resources/xml/1.xml")).join(" ")
      assert_equal(@expected, @xlo.get_error, 'Assertion was false.')
    end
  end
