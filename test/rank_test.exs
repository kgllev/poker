defmodule RankTest do
  use ExUnit.Case
  doctest Rank

  test "choose rank straight flush" do
    assert "9,0807060504" == Rank.rank(Hand.parse("4D 5D 6D 7D 8D"))
  end

  test "choose rank four of a kind" do
    assert "8,0404040414" == Rank.rank(Hand.parse("4H 4D 4S 4C AH"))
  end

  test "choose rank full house" do
    assert "7,0303030909" == Rank.rank(Hand.parse("3H 3C 3S 9H 9C"))
  end

  test "choose rank flush" do
    assert "6,1410080502" == Rank.rank(Hand.parse("2H 5H 8H TH AH"))
  end

  test "choose rank straight ace high" do
    assert "5,0908070605" == Rank.rank(Hand.parse("5H 6C 7S 8C 9H"))
  end

  test "choose rank straight ace low" do
    assert "5,0908070605" == Rank.rank(Hand.parse("5H 6C 7S 8C 9H"))
  end

  test "choose rank three of a kind" do
    assert "4,0303030902" == Rank.rank(Hand.parse("3H 3S 3D 2H 9C"))
  end

  test "choose rank two pair" do
    assert "3,0707060613" == Rank.rank(Hand.parse("7H 7C KD 6C 6D"))
    assert "3,0909080802" == Rank.rank(Hand.parse("9H 2H 9C 8D 8S"))

    assert "3,0606030302" == Rank.rank(Hand.parse("3S 6C 2C 6S 3H"))
  end

  test "choose rank pair" do
    assert "2,0808130604" == Rank.rank(Hand.parse("8C 4S 6H 8D KH"))
  end

  test "choose rank high card" do
    assert "1,1310060402" == Rank.rank(Hand.parse("6H 4C TD 2H KC"))
  end

  test "format rank for high card" do
    assert "1,1405040302" == Rank.format_high_card(Hand.parse("AS 2H 3H 4H 5H"))
    assert "1,0605040302" == Rank.format_high_card(Hand.parse("6S 2H 3H 4H 5H"))
    assert "1,0605040302" == Rank.format_high_card(Hand.parse("3H 2H 6S 4H 5H"))
  end

  test "format rank for a pair" do
    assert "2,0707040302" == Rank.format_pair(Hand.parse("7H 7C 2D 4C 3D"))
    assert "2,0707020203" == Rank.format_pair(Hand.parse("7H 2C 2D 7C 3D"))
    assert "2,0808130604" == Rank.format_pair(Hand.parse("8C 4S 6H 8D KH"))
  end

  test "format rank for two pair" do
    assert "3,0707060602" == Rank.format_two_pair(Hand.parse("7H 7C 2D 6C 6D"))
    assert "3,0707060603" == Rank.format_two_pair(Hand.parse("7H 6C 6D 7C 3D"))
    assert "3,0707060613" == Rank.format_two_pair(Hand.parse("7H 6C 6D 7C KD"))
  end

  test "format rank for three of a kind" do
    assert "4,0707070302" == Rank.format_three_of_a_kind(Hand.parse("7H 7C 2D 7S 3D"))
    assert "4,0707070908" == Rank.format_three_of_a_kind(Hand.parse("7H 8C 9D 7C 7D"))
    assert "4,0707070906" == Rank.format_three_of_a_kind(Hand.parse("7H 7C 9D 7S 6D"))
  end

  test "format rank for a straight ace high" do
    assert "5,0807060504" == Rank.format_straight_ace_high(Hand.parse("4D 5H 6S 7D 8H"))
    assert "5,0807060504" == Rank.format_straight_ace_high(Hand.parse("8H 4D 6S 5H 7D"))

    # ace high
    assert "5,1413121110" == Rank.format_straight_ace_high(Hand.parse("KH TC JH QH AH"))
  end

  test "format rank for a straight ace low" do
    assert "5,0807060504" == Rank.format_straight_ace_low(Hand.parse("4D 5H 6S 7D 8H"))
    assert "5,0807060504" == Rank.format_straight_ace_low(Hand.parse("8H 4D 6S 5H 7D"))

    # ace low
    assert "5,0504030201" == Rank.format_straight_ace_low(Hand.parse("3H 2C 4D AH 5D"))
  end

  test "format rank for a flush" do
    assert "6,1107050302" == Rank.format_flush(Hand.parse("2D 5D JD 7D 3D"))
    assert "6,1107050202" == Rank.format_flush(Hand.parse("2D 5D JD 7D 2D"))
  end

  test "format rank for a full house" do
    assert "7,0707070303" == Rank.format_full_house(Hand.parse("7D 7C 3H 7S 3D"))
    assert "7,0707070808" == Rank.format_full_house(Hand.parse("8H 7D 8C 7S 7H"))
  end

  test "format rank a four of a kind" do
    assert "8,0404040402" == Rank.format_four_of_a_kind(Hand.parse("2H 4D 4H 4S 4C"))
    assert "8,0404040405" == Rank.format_four_of_a_kind(Hand.parse("5H 4D 4H 4S 4C"))
  end

  test "format rank a straight flush ace high" do
    assert "9,0807060504" == Rank.format_straight_flush_ace_high(Hand.parse("4D 5D 6D 7D 8D"))
    assert "9,0807060504" == Rank.format_straight_flush_ace_high(Hand.parse("8H 4H 6H 5H 7H"))
    assert "9,1413121110" == Rank.format_straight_flush_ace_high(Hand.parse("KS JS QS AS TS"))
  end

  test "format rank a straight flush ace low" do
    assert "9,0807060504" == Rank.format_straight_flush_ace_low(Hand.parse("4D 5D 6D 7D 8D"))
    assert "9,0807060504" == Rank.format_straight_flush_ace_low(Hand.parse("8D 4D 6D 5D 7D"))
    assert "9,0504030201" == Rank.format_straight_flush_ace_low(Hand.parse("4H 2H 5H AH 3H"))
  end
end
