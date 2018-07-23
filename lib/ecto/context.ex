defmodule UtilityBelt.Ecto.QueryContext do
  @moduledoc """
  Query context
  """
  defstruct name: :basic,
            repo: nil,
            query: nil,
            parent: %{},
            paging: %{},
            fields: [],
            args: %{},
            extra_fields: [],
            total_fn: nil,
            aggr_fn: nil
end

defmodule UtilityBelt.Ecto.UpdateContext do
  @moduledoc """
  Query context
  """
  defstruct repo: nil,
            schema: nil,
            data: nil,
            changeset: nil,
            opts: nil,
            fields: nil,
            query: nil
end
