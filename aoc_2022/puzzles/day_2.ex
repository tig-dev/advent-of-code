defmodule Roshambo do
  @points [
    win: 6,
    draw: 3,
    lose: 0,
    rock: 1,
    paper: 2,
    scissors: 3
  ]

  @actions [
    A: :rock,
    B: :paper,
    C: :scissors,
    X: :rock,
    Y: :paper,
    Z: :scissors
  ]

  @outcomes [
    X: :lose,
    Y: :draw,
    Z: :win
  ]

  def get_points(key), do: Keyword.fetch!(@points, key)

  def get_action(key), do: Keyword.fetch!(@actions, key)

  def get_outcome(key), do: Keyword.fetch!(@outcomes, key)

  def split_input(input), do: String.split(input, "\n")

  def pair_up_inputs(action_strings),
    do: Enum.map(action_strings, fn str -> {String.at(str, 0), String.at(str, 2)} end)

  def pair_to_actions({enemy, player}),
    do: {String.to_atom(enemy) |> get_action, String.to_atom(player) |> get_action}

  def pair_to_action_outcome({enemy, outcome}),
    do: {String.to_atom(enemy) |> get_action, String.to_atom(outcome) |> get_outcome}

  def resolve_actions({enemy, player}) do
    case {enemy, player} do
      {:rock, :paper} -> {:win, player}
      {:rock, :scissors} -> {:lose, player}
      {:rock, :rock} -> {:draw, player}
      {:scissors, :paper} -> {:lose, player}
      {:scissors, :scissors} -> {:draw, player}
      {:scissors, :rock} -> {:win, player}
      {:paper, :paper} -> {:draw, player}
      {:paper, :scissors} -> {:win, player}
      {:paper, :rock} -> {:lose, player}
    end
  end

  def solve_outcome({enemy, outcome}) do
    case {enemy, outcome} do
      {:rock, :win} -> {outcome, :paper}
      {:rock, :lose} -> {outcome, :scissors}
      {:rock, :draw} -> {outcome, :rock}
      {:scissors, :win} -> {outcome, :rock}
      {:scissors, :lose} -> {outcome, :paper}
      {:scissors, :draw} -> {outcome, :scissors}
      {:paper, :win} -> {outcome, :scissors}
      {:paper, :lose} -> {outcome, :rock}
      {:paper, :draw} -> {outcome, :paper}
    end
  end

  def calc_score({outcome, player}), do: get_points(outcome) + get_points(player)

  def get_score(input_pair, "actions"),
    do: pair_to_actions(input_pair) |> resolve_actions |> calc_score

  def get_score(input_pair, "outcomes"),
    do: pair_to_action_outcome(input_pair) |> solve_outcome |> calc_score

  def get_scores(input_pairs, method),
    do: Enum.map(input_pairs, fn pair -> get_score(pair, method) end)

  def get_total_score(input, method) do
    split_input(input)
    |> pair_up_inputs
    |> get_scores(method)
    |> Enum.sum()
  end
end

inputs = File.read!(File.cwd!() <> "/puzzles/inputs/day_2.txt") |> String.trim_trailing

Roshambo.get_total_score(inputs, "actions") |> IO.inspect(label: "Part 1")
Roshambo.get_total_score(inputs, "outcomes") |> IO.inspect(label: "Part 2")
