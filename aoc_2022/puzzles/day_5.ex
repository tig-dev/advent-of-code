defmodule Crates do
  def split_rows(input), do: String.split(input, "\n")
  def get_stacks_and_moves(input), do: String.split(input, "\n\n")

  def prep_stacks(stacks),
    do:
      Enum.map(stacks, fn stack_row ->
        # split up every character
        String.split(stack_row, "")
        # every crate uses 4 chars on each line
        |> Enum.chunk_every(4)
        |> Enum.map(fn crate ->
          # remove whitespace and brackets from chunks
          Enum.filter(crate, fn x -> !Enum.member?(["", " ", "[", "]"], x) end)
        end)
        # remove extra [] at end of chunks
        |> Enum.drop(-1)
        |> Enum.map(fn crate ->
          # flatten the rows without losing blanks to preserve indexes
          if !Enum.empty?(crate), do: hd(crate), else: []
        end)
      end)
      # reverse so we can prepend into stacks, stack #s end up on top
      # we want to keep these #s so they end up adding keys to the stack map later
      |> Enum.reverse()

  def get_stacks(in_stacks),
    do:
      prep_stacks(in_stacks)
      |> Enum.map(fn row ->
        # for each row:
        # pair up crate slots with their 0-start indexes
        Enum.with_index(row)
        # remove empty slots now that we don't need them to preserve indexes
        |> Enum.filter(fn {slot, _} -> slot !== [] end)
        # add 1 to all indexes so they match to keys
        |> Enum.map(fn {slot, index} -> {index + 1, slot} end)
      end)
      # order is preserved here
      |> List.flatten()
      |> Enum.reduce(%{}, fn {stack_num, crate}, acc ->
        # turn list of crates into a map of stacks
        Map.update(acc, stack_num, [], fn curr_stack -> [crate | curr_stack] end)
      end)

  def prep_moves(in_moves),
    do:
      Enum.map(in_moves, fn move ->
        String.split(move, " ")
        |> Enum.filter(fn str -> String.match?(str, Regex.compile!("\\d")) end)
        |> Enum.reduce({}, fn str, acc -> Tuple.append(acc, String.to_integer(str)) end)
      end)

  def do_CrateMover_9000_move({0, _, _}, acc), do: acc
  def do_CrateMover_9000_move({count, src, dest}, acc) do
    {crate, stacks} = Map.get_and_update(acc, src, fn [head | tail] -> {head, tail} end)
    do_CrateMover_9000_move({count - 1, src, dest}, Map.update!(stacks, dest, fn curr_stack -> [crate | curr_stack] end))
  end

  def do_all_CrateMover_9000_moves(stacks, moves),
    do: Enum.reduce(moves, stacks, fn move, acc -> do_CrateMover_9000_move(move, acc) end)

  def do_CrateMover_9001_move({count, src, dest}, acc) do
    {crates, stacks} = Map.get_and_update(acc, src, fn curr_stack -> Enum.split(curr_stack, count) end)
    Map.update!(stacks, dest, fn curr_stack -> Enum.concat(crates, curr_stack) end)
  end

  def do_all_CrateMover_9001_moves(stacks, moves),
    do: Enum.reduce(moves, stacks, fn move, acc -> do_CrateMover_9001_move(move, acc) end)

  def get_CrateMover_9000_top_crates(input) do
    [stacks, moves] = get_stacks_and_moves(input)

    do_all_CrateMover_9000_moves(
      stacks |> split_rows |> get_stacks,
      moves |> split_rows |> prep_moves
    )
    |> Map.values()
    |> Enum.reduce("", fn stack, acc -> acc <> hd stack end)
  end

  def get_CrateMover_9001_top_crates(input) do
    [stacks, moves] = get_stacks_and_moves(input)

    do_all_CrateMover_9001_moves(
      stacks |> split_rows |> get_stacks,
      moves |> split_rows |> prep_moves
    )
    |> Map.values()
    |> Enum.reduce("", fn stack, acc -> acc <> hd stack end)
  end
end

inputs = File.read!(File.cwd!() <> "/puzzles/inputs/day_5.txt") |> String.trim_trailing()

Crates.get_CrateMover_9000_top_crates(inputs) |> IO.inspect(label: "Part 1")
Crates.get_CrateMover_9001_top_crates(inputs) |> IO.inspect(label: "Part 2")
