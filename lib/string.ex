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
end
