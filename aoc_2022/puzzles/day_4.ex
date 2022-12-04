defmodule Cleanup do
  def split_input(input), do: String.split(input, ["\n", ",", "-"])

  def chunk_input(inputs),
    do:
      Enum.map(inputs, fn x -> String.to_integer(x) end)
      |> Enum.chunk_every(2)
      |> Enum.chunk_every(2)

  def pair_to_range(first, second), do: first..second |> Enum.to_list()

  def get_all_ranges(pairs),
    do:
      Enum.map(pairs, fn [[first_1, first_2], [second_1, second_2]] ->
        [pair_to_range(first_1, first_2), pair_to_range(second_1, second_2)]
      end)

  def complete_overlap?(first, second),
    do: Enum.empty?(first -- second) || Enum.empty?(second -- first)

  def any_overlap?(first, second),
    do: List.myers_difference(first, second) |> Keyword.has_key?(:eq)

  def check_complete_overlaps(pairs),
    do: Enum.map(pairs, fn [first, second] -> complete_overlap?(first, second) end)

  def check_any_overlaps(pairs),
    do: Enum.map(pairs, fn [first, second] -> any_overlap?(first, second) end)

  def get_total_complete_overlaps(input) do
    split_input(input)
    |> chunk_input
    |> get_all_ranges
    |> check_complete_overlaps
    |> Enum.count(&(&1))
  end

  def get_total_overlaps(input) do
    split_input(input)
    |> chunk_input
    |> get_all_ranges
    |> check_any_overlaps
    |> Enum.count(&(&1))
  end
end

inputs = File.read!(File.cwd!() <> "/puzzles/inputs/day_4.txt")

Cleanup.get_total_complete_overlaps(inputs) |> IO.inspect(label: "Part 1")
Cleanup.get_total_overlaps(inputs) |> IO.inspect(label: "Part 2")
