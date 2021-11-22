defmodule Hand do
  @moduledoc """
  A single poker hand of cards.
  """

  def name(hand) do
    cond do
      Hand.is_straight_flush_ace_high(hand) -> "straight flush"
      Hand.is_straight_flush_ace_low(hand) -> "straight flush"
      Hand.is_four_of_a_kind(hand) -> "four of a kind"
      Hand.is_full_house(hand) -> "full house"
      Hand.is_flush(hand) -> "flush"
      Hand.is_straight_ace_high(hand) -> "straight"
      Hand.is_straight_ace_low(hand) -> "straight"
      Hand.is_three_of_a_kind(hand) -> "three of a kind"
      Hand.is_two_pair(hand) -> "two pair"
      Hand.is_pair(hand) -> "pair"
      Hand.is_high_card(hand) -> "high card"
    end
  end

  def format(hand) do
    Enum.map(hand, fn card -> Card.format(card) end)
    |> Enum.join(" ")
  end

  def parse(hand) do
    card_codes = String.split(hand, " ")
    Enum.map(card_codes, fn card -> Card.parse(card) end)
  end

  def winner(hand1, hand2) do
    rank1 = Rank.rank(hand1)
    rank2 = Rank.rank(hand2)

    cond do
      rank1 > rank2 -> hand1
      rank1 < rank2 -> hand2
      true -> false
    end
  end

  #
  # Hand identification
  #
  #  Input:  [[:heart, :seven], [:club, :seven], [:diamond, :two], [:spade, :seven], [:diamond, :three]]
  #

  def is_high_card(_) do
    true
  end

  @doc "Pair: 2 of the 5 cards in the hand have the same value."
  def is_pair(hand) do
    Enum.group_by(hand, fn [_, face] -> face end)
    |> Enum.find(fn {_, cards} -> length(cards) == 2 end)
  end

  @doc "Two Pairs: The hand contains 2 different pairs."
  def is_two_pair(hand) do
    2 ==
      Enum.group_by(hand, fn [_, face] -> face end)
      |> Enum.filter(fn {_, cards} -> length(cards) == 2 end)
      |> length
  end

  @doc "Three of a Kind: Three of the cards in the hand have the same value."
  def is_three_of_a_kind(hand) do
    Enum.group_by(hand, fn [_, face] -> face end)
    |> Enum.filter(fn {_, cards} -> length(cards) == 3 end)
    |> Enum.empty?() == false
  end

  @doc "Straight: Hand contains 5 cards with consecutive values. ace high"
  def is_straight_ace_high(hand) do
    Enum.sort(hand, fn [_, face1], [_, face2] ->
      Card.rank(face1, :ace) < Card.rank(face2, :ace)
    end)
    |> face_differences(:ace) == [1, 1, 1, 1]
  end

  @doc "Straight: Hand contains 5 cards with consecutive values. ace low"
  def is_straight_ace_low(hand) do
    Enum.sort(hand, fn [_, face1], [_, face2] ->
      Card.rank(face1, :ace_low) < Card.rank(face2, :ace_low)
    end)
    |> face_differences(:ace_low) == [1, 1, 1, 1]
  end

  defp face_differences(cards, ace) do
    face_differences(cards, [], ace)
  end

  defp face_differences([_ | []], differences, _), do: differences

  defp face_differences([last_card | remaining_cards], differences, ace) do
    next_card = hd(remaining_cards)

    last_value = String.to_integer(Card.rank(last_card, ace))
    next_value = String.to_integer(Card.rank(next_card, ace))

    differences = differences ++ [next_value - last_value]

    face_differences(remaining_cards, differences, ace)
  end

  @doc "Flush: Hand contains 5 cards of the same suit"
  def is_flush(hand) do
    1 == Enum.group_by(hand, fn [suit, _] -> suit end) |> Map.size()
  end

  @doc "Full House: 3 cards of the same value, with the remaining 2 cards forming a pair."
  def is_full_house(hand) do
    face_group([2, 3], hand)
  end

  @doc "Four of a kind: 4 cards with the same value"
  def is_four_of_a_kind(hand) do
    face_group([1, 4], hand)
  end

  defp face_group(members, hand) do
    by_face = Enum.group_by(hand, fn [_, face] -> face end)

    Map.size(by_face) == 2 &&
      Enum.count(by_face, fn {_, cards} -> Enum.member?(members, length(cards)) end) == 2
  end

  @doc "Straight flush: 5 cards of the same suit with consecutive values"
  def is_straight_flush_ace_high(hand) do
    is_straight_ace_high(hand) && is_flush(hand)
  end

  @doc "Straight flush: 5 cards of the same suit with consecutive values"
  def is_straight_flush_ace_low(hand) do
    is_straight_ace_low(hand) && is_flush(hand)
  end
end
