defmodule UtilityBelt.Priv do
  @moduledoc """
  Functionality for operating priv folder.
  """
  def load_file(app, path) do
    app
    |> Application.app_dir()
    |> Path.join(Path.join("priv", path))
    |> File.read!()
  end
end
