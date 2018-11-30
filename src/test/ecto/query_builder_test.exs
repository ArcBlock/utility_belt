defmodule UtilityBelt.QueryBuilderTest do
  @moduledoc false
  use ExUnit.Case
  import Ecto.Query
  alias UtilityBelt.Ecto.QueryBuilder, as: Builder

  test "build with select" do
    query = from(u in "user", where: u.id == 100_086)
    assert query.select == nil
    fields = [:id, :username, :name, :age]
    query_new = Builder.with_select(query, fields)
    %Ecto.Query.SelectExpr{take: take} = query_new.select
    assert take[0] == {:any, [:id, :username, :name, :age]}
  end

  test "build with limit for simple query" do
    query = from(u in "user", where: u.id == 100_086)
    assert query.limit == nil
    assert query.offset == nil
    cursor = 100
    page = 10
    query_new = Builder.with_limit(query, cursor, page)
    %Ecto.Query.QueryExpr{params: params} = query_new.limit
    assert params == [{page, :integer}]
    %Ecto.Query.QueryExpr{params: params} = query_new.offset
    assert params == [{cursor, :integer}]
  end

  test "build with limit for simple join" do
    query = from(u in "user", join: p in "profile", where: u.id == p.id)
    assert query.limit == nil
    cursor = 100
    page = 10
    query_new = Builder.with_limit(query, cursor, page)
    %Ecto.Query.QueryExpr{params: params} = query_new.limit
    assert params == [{page, :integer}]
    %Ecto.Query.QueryExpr{params: params} = query_new.offset
    assert params == [{cursor, :integer}]
  end

  test "build with limit for sub query" do
    query =
      from(
        u in "user",
        join: s in subquery(from(p in "post", order_by: [desc: p.inserted_at])),
        on: s.user_id == u.id
      )

    assert query.limit == nil
    assert query.offset == nil
    cursor = 100
    page = 10
    query_new = Builder.with_limit(query, cursor, page)
    %Ecto.Query.QueryExpr{params: params} = query_new.limit
    assert params == [{page, :integer}]
    %Ecto.Query.QueryExpr{params: params} = query_new.offset
    assert params == [{cursor, :integer}]
  end

  test "build with limit for sub query, set limit/offset to -1" do
    query =
      from(
        u in "user",
        join: s1 in subquery(from(p in "post", offset: -1, limit: -1)),
        join: s2 in subquery(from(c in "comment")),
        on: s1.user_id == u.id and s2.user_id == u.id
      )

    assert query.limit == nil
    cursor = 100
    page = 10
    query_new = Builder.with_limit(query, cursor, page)
    assert query_new.limit == nil
    assert query_new.limit == nil
    [%Ecto.Query.JoinExpr{source: s1}, %Ecto.Query.JoinExpr{source: s2}] = assert query_new.joins
    assert s1.query.limit.expr == page
    assert s1.query.offset.expr == cursor
    assert s2.query.limit == nil
    assert s2.query.offset == nil
  end

  test "build with simple where" do
    query = from(u in "user", limit: 10)
    query_new = Builder.with_simple_where(query, age: 50, gender: "F")
    [where | _] = query_new.wheres
    assert where.params == [{50, {0, :age}}, {"F", {0, :gender}}]
  end
end
