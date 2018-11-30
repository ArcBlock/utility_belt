defmodule UtilityBelt.Config do
  @moduledoc """
  Configuration related functions
  """
  def update(_app, _key, nil), do: :ok

  def update(app, key, value), do: Application.put_env(app, key, value)
end
