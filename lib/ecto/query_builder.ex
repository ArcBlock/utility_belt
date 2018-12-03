defmodule UtilityBelt.Ecto.QueryBuilder do
  @moduledoc """
  composite queries for complex situation
  """
  import Ecto.Query

  def with_select(query, []), do: query

  def with_select(query, fields) do
    case query.select do
      nil -> select(query, ^fields)
      _ -> query
    end
  end

  def with_simple_where(query, args) when is_map(args),
    do: with_simple_where(query, Enum.map(args, fn item -> item end))

  def with_simple_where(query, args) when is_list(args), do: where(query, ^args)
  def with_simple_where(_query, args), do: throw("Cannot process query with #{inspect(args)}")

  def with_limit(query, cursor, size) do
    case query.joins do
      [] ->
        query
        |> offset(^cursor)
        |> limit(^size)

      joins ->
        new_joins = Enum.map(joins, &limit_sub_query(&1, cursor, size))

        case Map.put(query, :joins, new_joins) do
          ^query ->
            query
            |> offset(^cursor)
            |> limit(^size)

          new_query ->
            new_query
        end
    end
  end

  defp limit_sub_query(join, cursor, size) do
    join
    |> update_in([Access.key!(:source), Access.key!(:query), Access.key!(:limit)], fn limit ->
      case limit.expr do
        -1 ->
          %Ecto.Query.QueryExpr{limit | expr: size}

        _ ->
          limit
      end
    end)
    |> update_in([Access.key!(:source), Access.key!(:query), Access.key!(:offset)], fn offset ->
      case offset.expr do
        -1 ->
          %Ecto.Query.QueryExpr{offset | expr: cursor}

        _ ->
          offset
      end
    end)
  rescue
    # TODO (tchen): need a better solution for inner sub query issue
    _e ->
      join
  end
end
