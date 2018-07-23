defmodule UtilityBelt.StringUtils do
  @moduledoc """
  String related utility
  """
  def to_integer(str) do
    String.to_integer(str)
  rescue
    _ -> str
  end

  def to_float(str) do
    String.to_float(str)
  rescue
    _ -> str
  end

  def get_last_item(str, splitter) do
    str
    |> String.split(splitter)
    |> Enum.take(-1)
    |> List.first()
  end

  def mod_to_snake(mod) do
    mod |> Atom.to_string() |> get_last_item(".") |> Recase.to_snake()
  end
end
