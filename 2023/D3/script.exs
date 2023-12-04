#/usr/bin/env elixir
# script.exs
# Day 3: I hate 2-d arrays :(

defmodule Day3_1 do
  def keep(p, s, ll) do
    #num, {index, length}
    {_, {i, l}} = p

    # Totally not caring about edge-cases... maybe I'll get lucky?
    Enum.slice(s, (i - ll - 1)..(i - ll + l)) ++
    Enum.slice(s, (i - 1)..(i + l)) ++
    Enum.slice(s, (i + ll - 1)..(i + ll + l))
    |> Enum.join
    |> String.match?(~r/[^0-9.]/)
  end

  def run do
    line_length = 1 + (List.first(C.ri) |> String.length)
    schematic = C.ri_D3
    s_bits = schematic |> String.graphemes

    numbers = Regex.scan(~r/(?=[^0-9]([0-9]+)[^0-9])/, schematic)
    |> Enum.map(fn pairing -> List.last(pairing) end)
    indices = Regex.scan(~r/(?=[^0-9]([0-9]+)[^0-9])/, schematic, return: :index)
    |> Enum.map(fn pairing -> List.last(pairing) end)

    Enum.zip(numbers, indices)
    |> Enum.filter(fn pairing -> keep(pairing, s_bits, line_length) end)
    |> Enum.map(fn pairing -> pairing |> elem(0) |> Integer.parse |> elem(0) end)
    |> Enum.sum
    |> IO.inspect(limit: :infinity)
  end
end

defmodule Day3_2 do
  def possible_gear(p, s, ll) do
    #num, {index, length}
    {n, {i, l}} = p

    # Totally not caring about edge-cases... maybe I'll get lucky?
    above = Enum.slice(s, (i - 1)..(i + l))
    |> Enum.with_index(fn el, ind -> {ind, el} end)
    |> Enum.filter(fn {_, el} -> el == "*" end)
    |> Enum.map(fn {ind, _} -> {n |> Integer.parse |> elem(0), i - 1 + ind} end)

    current = Enum.slice(s, (i - ll - 1)..(i - ll + l))
    |> Enum.with_index(fn el, ind -> {ind, el} end)
    |> Enum.filter(fn {_, el} -> el == "*" end)
    |> Enum.map(fn {ind, _} -> {n |> Integer.parse |> elem(0), i - ll - 1 + ind} end)

    below = Enum.slice(s, (i + ll - 1)..(i + ll + l))
    |> Enum.with_index(fn el, ind -> {ind, el} end)
    |> Enum.filter(fn {_, el} -> el == "*" end)
    |> Enum.map(fn {ind, _} -> {n |> Integer.parse |> elem(0), i + ll - 1 + ind} end)

    above ++ current ++ below
  end

  def run do
    line_length = 1 + (List.first(C.ri) |> String.length)
    schematic = C.ri_D3
    s_bits = schematic |> String.graphemes

    numbers = Regex.scan(~r/(?=[^0-9]([0-9]+)[^0-9])/, schematic)
    |> Enum.map(fn pairing -> List.last(pairing) end)
    indices = Regex.scan(~r/(?=[^0-9]([0-9]+)[^0-9])/, schematic, return: :index)
    |> Enum.map(fn pairing -> List.last(pairing) end)

    Enum.zip(numbers, indices)
    |> Enum.map(fn pairing -> possible_gear(pairing, s_bits, line_length) end)
    |> List.flatten
    |> Enum.group_by(fn {_, gear_i} -> gear_i end)
    |> Map.filter(fn {_, pairs} -> length(pairs) == 2 end)
    |> Map.values
    |> Enum.map(fn pairs -> (List.first(pairs) |> elem(0)) * (List.last(pairs) |> elem(0)) end)
    |> Enum.sum
    |> IO.inspect
  end
end

Day3_1.run()
Day3_2.run()
