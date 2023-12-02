# common.ex

defmodule C do
  def ri1 do
    Regex.split( ~r/\r|\n|\r\n/, String.trim(File.read!("input1.txt")))
  end
  def ri2 do
    Regex.split( ~r/\r|\n|\r\n/, String.trim(File.read!("input2.txt")))
  end
end
