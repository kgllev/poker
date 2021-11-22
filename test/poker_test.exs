defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "runs game" do
    hand1 = "2H 3D 5S 9C"
    hand2 = "2C 3H 4S 8C AH"
    {hand1, hand2, winner} = Poker.play(hand1, hand2)

    assert hand1
    assert hand2
    assert hand1 == winner || hand2 == winner
  end
end
