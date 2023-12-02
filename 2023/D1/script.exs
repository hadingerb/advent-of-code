#/usr/bin/env elixir
# script.exs
# Day 1: Decyphering the Calibration

defmodule Day1_1 do
  def run do
    input = C.ri1

    total = for val <- input, reduce: 0 do
      acc ->
        {ints, _} = Integer.parse(Regex.replace(~r"[a-z/]", val, ""))
        intsl = Integer.digits(ints)
        acc + List.first(intsl) * 10 + List.last(intsl)
    end
    IO.puts(total)
  end
end

defmodule Day1_2 do
  def run do
    input = C.ri2

    num_map = %{
      "1" => 1, "one" => 1,
      "2" => 2, "two" => 2,
      "3" => 3, "three" => 3,
      "4" => 4, "four" => 4,
      "5" => 5, "five" => 5,
      "6" => 6, "six" => 6,
      "7" => 7, "seven" => 7,
      "8" => 8, "eight" => 8,
      "9" => 9, "nine" => 9
    }

    total = for val <- input, reduce: 0 do
      acc ->
        numbers = Regex.scan(~r/(?=([0-9]|one|two|three|four|five|six|seven|eight|nine))/, val)
        IO.inspect(numbers)
        intsl = Enum.map(numbers, fn x -> List.last(x) end)
        f = List.first(intsl); l = List.last(intsl)
        acc + num_map[f] * 10 + num_map[l] 
    end
    IO.puts(total)
  end
end

Day1_1.run()
Day1_2.run()
