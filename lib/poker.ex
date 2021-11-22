defmodule Poker do
  @moduledoc """
  The game of Poker
  """

  def main(hand1, hand2) do
    {hand1, hand2, winner} = play(hand1, hand2)

    case hand1 != winner && hand2 != winner do
      true ->
        IO.puts("#{Hand.format(hand1)}")
        IO.puts("#{Hand.format(hand2)}")
        IO.puts("Tie")

      _ ->
        report(hand1, "Black wins", hand1 == winner)
        report(hand2, "White wins", hand2 == winner)
    end
  end

  def play(hand1, hand2) do
    hand1 = Hand.parse(hand1)
    hand2 = Hand.parse(hand2)

    {hand1, hand2, Hand.winner(hand1, hand2)}
  end

  defp report(hand, message, true), do: IO.puts("#{Hand.format(hand)},  #{message} - #{String.pad_trailing(Hand.name(hand), 14)}")
  defp report(hand, _message, false), do: IO.puts("#{Hand.format(hand)}")
end
