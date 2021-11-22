# Rank Encoding
#
# Rank for Hands
# 9 - straight flush + highest card
# 8 - four of a kind + card value
# 7 - full house + 3 card value
# 6 - flush + highest cards
# 5 - straight (can be ace high) + highest card
# 4 - three of a kind + 3 card value
# 3 - two pair + highest pairs + remaining card
# 2 - pair + 2 card value + highest cards
# 1 - high card + highest cards
#
# Face Value Rank
# ace   - 14
# king  - 13
# queen - 12
# jack  - 11
# ten   - 10
# 9     - 09
# ...
# 2     - 02
# ace   - 01   <<< ace as a low card
#
# Rank Code
# [ rank code, sorted faces ]
# e.g.
# - 1, 0504030201
# - 1, 0605040302 WINNER
# - 4, 0404040201
# - 4, 0505050201 WINNER
defmodule Rank do
  @moduledoc "Rank a poker hand"

  def rank(hand) do
    cond do
      # Rank 9
      Hand.is_straight_flush_ace_high(hand) -> format_straight_flush_ace_high(hand)
      # Rank 9
      Hand.is_straight_flush_ace_low(hand) -> format_straight_flush_ace_low(hand)
      # Rank 8
      Hand.is_four_of_a_kind(hand) -> format_four_of_a_kind(hand)
      # Rank 7
      Hand.is_full_house(hand) -> format_full_house(hand)
      # Rank 6
      Hand.is_flush(hand) -> format_flush(hand)
      # Rank 5
      Hand.is_straight_ace_high(hand) -> format_straight_ace_high(hand)
      # Rank 5
      Hand.is_straight_ace_low(hand) -> format_straight_ace_low(hand)
      # Rank 4
      Hand.is_three_of_a_kind(hand) -> format_three_of_a_kind(hand)
      # Rank 3
      Hand.is_two_pair(hand) -> format_two_pair(hand)
      # Rank 2
      Hand.is_pair(hand) -> format_pair(hand)
      # Rank 1
      Hand.is_high_card(hand) -> format_high_card(hand)
    end
  end

  @doc """
  Format methods:
  Input:  [[:heart, :seven], [:club, :seven], [:diamond, :two], [:spade, :seven], [:diamond, :three]]
  Output: "4,0707070302"
  """

  def format_high_card(hand) do
    sort_by_face(hand, "1", :ace)
  end

  def format_pair(hand) do
    sort_by_count_and_face(hand, "2", :ace)
  end

  def format_two_pair(hand) do
    sort_by_count_and_face(hand, "3", :ace)
  end

  def format_three_of_a_kind(hand) do
    sort_by_count_and_face(hand, "4", :ace)
  end

  def format_straight_ace_high(hand) do
    sort_by_face(hand, "5", :ace)
  end

  def format_straight_ace_low(hand) do
    sort_by_face(hand, "5", :ace_low)
  end

  def format_flush(hand) do
    sort_by_face(hand, "6", :ace)
  end

  def format_full_house(hand) do
    sort_by_count_and_face(hand, "7", :ace)
  end

  def format_four_of_a_kind(hand) do
    sort_by_count_and_face(hand, "8", :ace)
  end

  def format_straight_flush_ace_high(hand) do
    sort_by_count_and_face(hand, "9", :ace)
  end

  def format_straight_flush_ace_low(hand) do
    sort_by_count_and_face(hand, "9", :ace_low)
  end

  defp sort_by_face(hand, rank_code, ace) do
    Enum.map(hand, fn card -> Card.rank(card, ace) end)
    |> Enum.sort(fn face_rank1, face_rank2 -> face_rank1 > face_rank2 end)
    |> format_rank(rank_code)
  end

  defp sort_by_count_and_face(hand, rank_code, ace) do
    Enum.group_by(hand, fn [_, face] -> face end)
    |> Enum.sort(fn {face1, cards1}, {face2, cards2} ->
      "#{length(cards1)}|#{Card.rank(face1, ace)}" > "#{length(cards2)}|#{Card.rank(face2, ace)}"
    end)
    |> Enum.map(fn {_, cards} -> cards end)
    |> Enum.concat()
    |> Enum.map(fn card -> Card.rank(card, ace) end)
    |> format_rank(rank_code)
  end

  defp format_rank(hand, rank_code) do
    Enum.into(hand, ["#{rank_code},"])
    |> Enum.join()
  end
end
