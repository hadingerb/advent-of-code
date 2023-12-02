#/usr/bin/env elixir
# script.exs
# Day 2: I see cubes of green, red solids too, i see them bloom, even including blue
#        And i think to myself....... what a wonderful world!

defmodule Day2 do
  def max_color(counts) do
    Enum.map(counts, fn c ->
      String.replace(c, ~r/[a-z]/, "")
      |> Integer.parse
      |> elem(0) end)
    |> Enum.max
  end

  def run do
    input = C.ri

    max_colors = %{"red" => 12, "green" => 13, "blue" => 14}

    game_maxes = Enum.map(input, fn game ->
      {_, num, found} = List.to_tuple(List.first(Regex.scan(~r/Game ([0-9]+): (.+)/, game)))
      {
        num |> Integer.parse |> elem(0),
        String.split(found, ~r/[,; ] /)
        |> Enum.group_by(fn n_c -> List.last(String.split(n_c, " ")) end)
        |> Enum.map(fn {color, counts} -> {color, max_color(counts)} end)
      }
    end)

    #Part 1
    game_maxes
    |> Enum.filter(fn {_, color_maxes} -> Enum.all?(color_maxes, fn {color, count} -> count <= max_colors[color] end) end)
    |> Enum.map(fn {game, _} -> game end)
    |> Enum.sum
    |> IO.inspect

    #Part 2
    game_maxes
    |> Enum.map(fn {_, color_maxes} ->
        Enum.map(color_maxes, fn {_, count} -> count end)
        |> Enum.product
    end)
    |> Enum.sum
    |> IO.inspect
  end
end

Day2.run()
