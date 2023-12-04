# common.ex

defmodule C do
  def ri do
    Regex.split(~r/\r|\n|\r\n/, String.trim(File.read!("input.txt")))
  end
  def ri_D3 do
    Regex.replace(~r/\r|\n|\r\n/, File.read!("input.txt"), ".")
  end
end
