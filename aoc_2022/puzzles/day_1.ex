defmodule Calories do
  def split_input(input), do: String.split(input, "\n")

  def chunk_input(input),
    do:
      split_input(input)
      |> Enum.chunk_by(&(String.length(&1) == 0))

  def split_elf_invs(calories_list),
    do:
      chunk_input(calories_list)
      |> Enum.filter(&(String.length(Enum.fetch!(&1, 0)) != 0))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

  def sum_elf_inv(inv), do: Enum.reduce(inv, fn x, acc -> x + acc end)

  def get_totals(calories_list),
    do:
      split_elf_invs(calories_list)
      |> Enum.map(&sum_elf_inv(&1))

  def get_highest(calories_list, places \\ 1),
    do:
      get_totals(calories_list)
      |> Enum.sort(:desc)
      |> Enum.take(places)
      |> Enum.sum()
end

inputs = File.read!(File.cwd!() <> "/puzzles/inputs/day_1.txt")

Calories.get_highest(inputs) |> IO.inspect(label: "Part 1")
Calories.get_highest(inputs, 3) |> IO.inspect(label: "Part 2")
