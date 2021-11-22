defmodule HandTest do
  use ExUnit.Case
  doctest Hand

  test "format hand as string" do
    hand = [[:heart, :two], [:spade, :ace], [:club, :king], [:club, :two], [:diamond, :ten]]

    assert "2H AS KC 2C TD" == Hand.format(hand)
  end

  test "format any number of cards" do
    hand = [[:heart, :two], [:spade, :ace]]

    assert "2H AS" == Hand.format(hand)
  end

  test "format empty string if there are no cards" do
    hand = []

    assert "" == Hand.format(hand)
  end

  test "parsing a hand" do
    assert [[:spade, :ace]] == Hand.parse("AS")

    assert [[:spade, :ace], [:heart, :two], [:heart, :three], [:heart, :four], [:heart, :five]] ==
             Hand.parse("AS 2H 3H 4H 5H")

    assert [["", ""]] == Hand.parse("")
  end

  test "format the name of the hand" do
    assert "straight flush" == Hand.name(Hand.parse("2C 3C 4C 5C 6C"))
    assert "straight flush" == Hand.name(Hand.parse("AC 2C 3C 4C 5C"))
    assert "four of a kind" == Hand.name(Hand.parse("AC AD AS AH 2C"))
    assert "four of a kind" == Hand.name(Hand.parse("KC KD KS KH 2C"))
    assert "full house" == Hand.name(Hand.parse("AC AD AH 2C 2D"))
    assert "full house" == Hand.name(Hand.parse("KC KD KH 2C 2D"))
    assert "flush" == Hand.name(Hand.parse("AC 3C 4C 5C 6C"))
    assert "flush" == Hand.name(Hand.parse("KC 3C 4C 5C 6C"))
    assert "straight" == Hand.name(Hand.parse("TC JD QD KD AD"))
    assert "straight" == Hand.name(Hand.parse("2C 3D 4D 5D 6D"))
    assert "straight" == Hand.name(Hand.parse("AC 2D 3D 4D 5D"))
    assert "three of a kind" == Hand.name(Hand.parse("AC AD AH 2C 3D"))
    assert "three of a kind" == Hand.name(Hand.parse("KC KD KH 2C 3D"))
    assert "two pair" == Hand.name(Hand.parse("AC AD 2C 2D 3C"))
    assert "two pair" == Hand.name(Hand.parse("KC KD 2C 2D 3C"))
    assert "pair" == Hand.name(Hand.parse("AC AD 2C 3C 4C"))
    assert "pair" == Hand.name(Hand.parse("KC KD 2C 3C 4C"))
    assert "high card" == Hand.name(Hand.parse("AC 3D 4C 5D 6C"))
    assert "high card" == Hand.name(Hand.parse("KC 3D 4C 5D 6C"))

    assert "two pair" == Hand.name(Hand.parse("3S 6C 2C 6S 3H"))
  end

  test "that the winnder is determined correctly" do
    decending_hands = [
      # 9 straight flush high
      Hand.parse("2C 3C 4C 5C 6C"),
      # 9 straight flush low
      Hand.parse("AC 2C 3C 4C 5C"),
      # 8 four of a kind high
      Hand.parse("AC AD AS AH 2C"),
      # 8 four of a kind low
      Hand.parse("KC KD KS KH 2C"),
      # 7 full house high
      Hand.parse("AC AD AH 2C 2D"),
      # 7 full house low
      Hand.parse("KC KD KH 2C 2D"),
      # 6 flush high
      Hand.parse("AC 3C 4C 5C 6C"),
      # 6 flush low
      Hand.parse("KC 3C 4C 5C 6C"),
      # 5 straight ace high
      Hand.parse("TC JD QD KD AD"),
      # 5 straight ace low
      Hand.parse("2C 3D 4D 5D 6D"),
      # 5 straight ace lower
      Hand.parse("AC 2D 3D 4D 5D"),
      # 4 three of a kind high
      Hand.parse("AC AD AH 2C 3D"),
      # 4 three of a kind low
      Hand.parse("KC KD KH 2C 3D"),
      # 3 two pair high
      Hand.parse("AC AD 2C 2D 3C"),
      # 3 two pair low
      Hand.parse("KC KD 2C 2D 3C"),
      # 2 pair high
      Hand.parse("AC AD 2C 3C 4C"),
      # 2 pair low
      Hand.parse("KC KD 2C 3C 4C"),
      # 1 high card high
      Hand.parse("AC 3D 4C 5D 6C"),
      # 1 high card low
      Hand.parse("KC 3D 4C 5D 6C")
    ]

    check_winner(hd(decending_hands), tl(decending_hands))
  end

  defp check_winner(winning_hand, remaining_hands) do
    case [winning_hand, remaining_hands] do
      [_, []] ->
        true

      [winning_hand, remaining_hands] ->
        assert winning_hand
               |> should_beat(hd(remaining_hands))

        check_winner(hd(remaining_hands), tl(remaining_hands))
    end
  end

  defp should_beat(hand1, hand2) do
    hand1 == Hand.winner(hand1, hand2)
  end

  test "its a draw" do
    hand1 = Hand.parse("KC 3D 4C 5D 6C")
    hand2 = Hand.parse("KS 3H 4S 5H 6S")

    assert false == Hand.winner(hand1, hand2)
  end

  test "is high card" do
    assert Hand.is_high_card(Hand.parse("AS 2H 3H 4H 5H"))
    assert Hand.is_high_card(Hand.parse("6S 2H 3H 4H 5H"))
    assert Hand.is_high_card(Hand.parse("3H 2H 6S 4H 5H"))
  end

  test "is a pair" do
    assert Hand.is_pair(Hand.parse("7H 7C 2D 4C 3D"))
    assert Hand.is_pair(Hand.parse("7H 2C 2D 7C 3D"))

    assert !Hand.is_pair(Hand.parse("4D 5H 6S 7D 8H"))
  end

  test "is two pair" do
    assert Hand.is_two_pair(Hand.parse("7H 7C 2D 6C 6D"))
    assert Hand.is_two_pair(Hand.parse("7H 6C 6D 7C 3D"))
    assert Hand.is_two_pair(Hand.parse("3S 6C 2C 6S 3H"))

    assert !Hand.is_two_pair(Hand.parse("7H 2C 6D 7C 3D"))
  end

  test "is three of a kind" do
    assert Hand.is_three_of_a_kind(Hand.parse("7H 7C 2D 7S 3D"))
    assert Hand.is_three_of_a_kind(Hand.parse("7H 8C 9D 7C 7D"))
    assert Hand.is_three_of_a_kind(Hand.parse("7H 7C 9D 7S 6D"))

    assert !Hand.is_three_of_a_kind(Hand.parse("7H 7C 2D 6C 6D"))
  end

  test "is a straight - ace high" do
    assert Hand.is_straight_ace_high(Hand.parse("4D 5H 6S 7D 8H"))
    assert Hand.is_straight_ace_high(Hand.parse("8H 4D 6S 5H 7D"))
    assert Hand.is_straight_ace_high(Hand.parse("TH JD QS KH AD"))

    assert !Hand.is_straight_ace_high(Hand.parse("3S 6C 2C 6S 3H"))
    assert !Hand.is_straight_ace_high(Hand.parse("JH 4D 6S 5H 7D"))
    assert !Hand.is_straight_ace_high(Hand.parse("AH 2D KS 3C 4H"))
    assert !Hand.is_straight_ace_high(Hand.parse("AH 2D 4S 3C 5H"))
  end

  test "is a straight - ace low" do
    assert Hand.is_straight_ace_low(Hand.parse("AH 2D 3S 4H 5D"))
    assert Hand.is_straight_ace_low(Hand.parse("AH 2D 4S 3C 5H"))

    assert !Hand.is_straight_ace_high(Hand.parse("3S 6C 2C 6S 3H"))
    assert !Hand.is_straight_ace_low(Hand.parse("AH 2D 8S 4H 5D"))
  end

  test "is a flush" do
    assert Hand.is_flush(Hand.parse("2D 5D JD 7D 3D"))
    assert Hand.is_flush(Hand.parse("2D 5D JD 7D 2D"))

    assert !Hand.is_flush(Hand.parse("2D 5H JD 7D 2D"))
    assert !Hand.is_flush(Hand.parse("2D 5D JD 7H 2D"))
    assert !Hand.is_flush(Hand.parse("2D 5D JD 7D 2C"))
  end

  test "is a full house" do
    assert Hand.is_full_house(Hand.parse("7D 7C 3H 7S 3D"))
    assert Hand.is_full_house(Hand.parse("8H 7D 8C 7S 7H"))
    assert Hand.is_full_house(Hand.parse("AH KD AC KS AS"))

    assert !Hand.is_full_house(Hand.parse("7H 7D 8C 7S 7H"))
    assert !Hand.is_full_house(Hand.parse("8H 7D 8C AS 7H"))
  end

  test "is four of a kind" do
    assert Hand.is_four_of_a_kind(Hand.parse("2H 4D 4H 4S 4C"))
    assert Hand.is_four_of_a_kind(Hand.parse("5H 4D 4H 4S 4C"))

    assert !Hand.is_four_of_a_kind(Hand.parse("4H 3D AH 4S 4C"))
  end

  test "is straight flush ace high" do
    assert Hand.is_straight_flush_ace_high(Hand.parse("4D 5D 6D 7D 8D"))
    assert Hand.is_straight_flush_ace_high(Hand.parse("8H 4H 6H 5H 7H"))
    assert Hand.is_straight_flush_ace_high(Hand.parse("AH KH QH JH TH"))

    assert !Hand.is_straight_flush_ace_high(Hand.parse("AH 2H 3H 4H 5H"))
    assert !Hand.is_straight_flush_ace_high(Hand.parse("8D 4H 6H 5H 7H"))
    assert !Hand.is_straight_flush_ace_high(Hand.parse("8H 4H 6S 5H 7H"))
    assert !Hand.is_straight_flush_ace_high(Hand.parse("8H AH 6H 5H 7H"))
  end

  test "is straight flush ace low" do
    assert Hand.is_straight_flush_ace_low(Hand.parse("4D 5D 6D 7D 8D"))
    assert Hand.is_straight_flush_ace_low(Hand.parse("8H 4H 6H 5H 7H"))
    assert Hand.is_straight_flush_ace_low(Hand.parse("AH 2H 3H 4H 5H"))

    assert !Hand.is_straight_flush_ace_low(Hand.parse("AH KH QH JH TH"))
    assert !Hand.is_straight_flush_ace_low(Hand.parse("8D 4H 6H 5H 7H"))
    assert !Hand.is_straight_flush_ace_low(Hand.parse("8H 4H 6S 5H 7H"))
    assert !Hand.is_straight_flush_ace_low(Hand.parse("8H AH 6H 5H 7H"))
  end
end
