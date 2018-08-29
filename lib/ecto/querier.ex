defmodule UtilityBelt.Ecto.Querier do
  @moduledoc """
  Helper functions for queries
  """
  require Logger
  alias Ecto.Adapters.SQL
  alias UtilityBelt.Ecto.Paginator
  alias UtilityBelt.Ecto.QueryBuilder, as: Builder
  alias UtilityBelt.Ecto.QueryContext

  @spec get(QueryContext.t()) :: [Ecto.Schema.t()]
  def get(context) do
    context
    |> build_full_condition_for_get()
    |> context.repo.all()
  end

  @spec build_full_condition_for_get(QueryContext.t()) :: Ecto.Query.t()
  def build_full_condition_for_get(context) do
    context.query
    |> Builder.with_select(get_fields(context))
    |> Builder.with_simple_where(context.args)
  end

  @spec get_list(QueryContext.t()) :: [Ecto.Schema.t()]
  def get_list(context) do
    data =
      context
      |> build_full_condition_for_get_list()
      |> context.repo.all()

    case context.aggr_fn do
      nil -> data
      fun -> fun.(data)
    end
  end

  @spec build_full_condition_for_get_list(QueryContext.t()) :: Ecto.Query.t()
  def build_full_condition_for_get_list(context) do
    {size, cursor} = Paginator.get_cursor(context)

    context.query
    |> Builder.with_select(get_fields(context))
    |> Builder.with_limit(cursor, size)
  end

  @spec print_sql(Ecto.Query.t(), atom()) :: Ecto.Query.t()
  def print_sql(query, repo) do
    {query, args} = SQL.to_sql(:all, repo, query)
    IO.puts("Query: #{query}. Params: #{inspect(args)}")
    query
  end

  @spec to_sql(Ecto.Query.t(), atom()) :: {String.t, [term]}
  def to_sql(query, repo) do
    SQL.to_sql(:all, repo, query)
  end

  # private functions
  @doc false
  defp get_fields(context) do
    (context.fields ++ context.extra_fields)
    |> Enum.uniq()
    |> Enum.sort()
  end
end
