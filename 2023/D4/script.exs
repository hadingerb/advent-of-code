#/usr/bin/env elixir
# script.exs
# Day 4: Betting is always a smart move

defmodule Day4 do
  def run do
    winnings = C.ri
    # Split cards on spaces
    |> Enum.map(fn card -> String.split(card, " ", trim: true) end)
    # Remove Card number
    |> Enum.map(fn card -> Enum.split_while(card, fn num -> String.at(num, -1) != ":" end) end)
    # Split lucky/mine
    |> Enum.map(fn {_, nums} -> Enum.split_while(tl(nums), fn num -> num != "|" end) end)
    # Intersect lucky/mine
    |> Enum.map(fn {lucky, mine} -> MapSet.intersection(MapSet.new(lucky), MapSet.new(tl(mine))) end)
    # Find total winning
    |> Enum.map(fn winning -> MapSet.to_list(winning) |> length end)

    # P1
    winnings
    |> Enum.filter(fn num -> num > 0 end)
    |> Enum.map(fn n -> Integer.pow(2, n - 1) end)
    |> Enum.sum
    |> IO.inspect

    # P2
    winnings
    |> add_winnings(0, List.duplicate(1, length(winnings)))
    |> IO.inspect
  end

  def add_winnings(winnings, index, total) do
    if index < length(total) do
      add_winnings(winnings, index + 1,
        total
        |> Enum.with_index(fn el, ind -> {ind, el} end)
        |> Enum.map(fn {ind, el} ->
          if ind > index and ind < Enum.min([length(total), index + Enum.at(winnings, index) + 1]) do
            el + Enum.at(total, index)
          else
            el
          end 
        end))
    else
      Enum.sum(total)
    end
  end
end

Day4.run()
