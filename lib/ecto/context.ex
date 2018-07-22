defmodule UtilityBelt.Ecto.Context do
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
