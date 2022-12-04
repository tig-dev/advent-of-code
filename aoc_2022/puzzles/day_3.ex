defmodule Rucksacks do
  # Found at: https://elixirforum.com/t/get-ascii-value-of-a-character/16619
  def str_char_to_ascii(char),
    do: char |> String.to_charlist() |> hd

  def split_input(input), do: String.split(input, "\n")

  def split_rucksack(rucksack),
    do: String.split_at(rucksack, String.length(rucksack) |> div(2)) |> Tuple.to_list

  def get_same_item([head | tail]),
    do:
      String.split(head, "")
      |> Enum.uniq()
      |> Enum.find(fn item ->
        if item != "" do
          Enum.all?(tail, fn sack -> String.contains?(sack, item) end)
        end
      end)

  def get_item_priority(item) do
    value = str_char_to_ascii(item)

    cond do
      value >= 97 ->
        value - 96

      value >= 65 ->
        value - 38
    end
  end

  def get_all_compartments(sacks),
    do: Enum.map(sacks, fn sack -> split_rucksack(sack) end)

  def get_all_matches(sacks),
    do: Enum.map(sacks, fn sack -> get_same_item(sack) end)

  def get_all_priorities(items),
    do: Enum.map(items, fn item -> get_item_priority(item) end)

  def get_total_matching_priorities(input) do
    split_input(input)
    |> get_all_compartments
    |> get_all_matches
    |> get_all_priorities
    |> Enum.sum()
  end

  def get_total_badge_priorities(input) do
    split_input(input)
    |> Enum.chunk_every(3)
    |> get_all_matches
    |> get_all_priorities()
    |> Enum.sum()
  end
end

inputs = File.read!(File.cwd!() <> "/puzzles/inputs/day_3.txt")

Rucksacks.get_total_matching_priorities(inputs) |> IO.inspect(label: "Part 1")
Rucksacks.get_total_badge_priorities(inputs) |> IO.inspect(label: "Part 2")
