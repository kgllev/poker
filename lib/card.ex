defmodule Card do
  @moduledoc """
  A single card
  """

  @suits %{
    :heart => "H",
    :diamond => "D",
    :spade => "S",
    :club => "C"
  }

  @faces %{
    :ace => "A",
    :two => "2",
    :three => "3",
    :four => "4",
    :five => "5",
    :six => "6",
    :seven => "7",
    :eight => "8",
    :nine => "9",
    :ten => "T",
    :jack => "J",
    :queen => "Q",
    :king => "K"
  }

  @face_ranks %{
    :ace_low => "01",
    :two => "02",
    :three => "03",
    :four => "04",
    :five => "05",
    :six => "06",
    :seven => "07",
    :eight => "08",
    :nine => "09",
    :ten => "10",
    :jack => "11",
    :queen => "12",
    :king => "13",
    :ace => "14"
  }

  def suits do
    Map.keys(@suits)
  end

  def faces do
    Map.keys(@faces)
  end

  def rank(card_or_face, ace \\ :ace)
  def rank([_, face], ace), do: rank(face, ace)

  def rank(face, ace) do
    case [face, ace] do
      [:ace, :ace_low] -> @face_ranks[:ace_low]
      [face, _] -> @face_ranks[face]
    end
  end

  def format_suit(suit) do
    @suits[suit]
  end

  def format_face(face) do
    @faces[face]
  end

  def format(card) do
    [suit, face] = card
    "#{format_face(face)}#{format_suit(suit)}"
  end

  def parse(card) do
    face = String.first(card)
    suit = String.last(card)

    [parse_suit(suit), parse_face(face)]
  end

  def parse_face(face) do
    find_key(@faces, face)
  end

  def parse_suit(suit) do
    find_key(@suits, suit)
  end

  defp find_key(collection, required_value) do
    found = Enum.find(collection, fn {_, value} -> value == required_value end)

    case found do
      nil -> ""
      _ -> elem(found, 0)
    end
  end
end
