defmodule UtilityBelt.ProjectTop do
  @moduledoc """
  Retrieve the top directory for elixir project
  """
  alias Mix.Project

  @max_recursive_level 5

  @doc """
  Recursively retrieve project top (the dir contains .git subdir)
  """
  @spec get() :: String.t()
  def get do
    path = Project.deps_path() |> Path.join("..")
    get_path(path, get_max_recursion_level())
  end

  defp get_path(path, 0), do: raise("Cannot find top path in #{path}")

  defp get_path(path, level) do
    case File.exists?(Path.join(path, '.git')) do
      true ->
        path

      _ ->
        get_path(Path.join(path, '..'), level - 1)
    end
  end

  defp get_max_recursion_level do
    :utility_belt
    |> Application.get_env(:project_top, [])
    |> Access.get(:max_level, @max_recursive_level)
  end
end
