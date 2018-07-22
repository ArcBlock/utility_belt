defmodule UtilityBelt.QueryTest do
  @moduledoc false
  use ExUnit.Case

  import Ecto.Query
  import UtilityBelt.Factory
  import Mock

  alias UtilityBelt.Db.Repo.TestUser
  alias UtilityBelt.Ecto.{Context, Query}

  test "simple query" do
    with_mock(TestUser, one: &repo_one/1, all: &repo_all/1) do
      query = from(u in "user", order_by: [desc: u.inserted_at])

      context = %Context{
        repo: TestUser,
        query: query,
        fields: [:username],
        args: %{age: 30},
        extra_fields: [:id]
      }

      data = Query.get(context)
      assert is_list(data) == true
    end
  end

  test "list query" do
    with_mock(TestUser, one: &repo_one/1, all: &repo_all/1) do
      query = from(u in "user", order_by: [desc: u.inserted_at])
      total = 100
      total_fn = fn _ -> total end
      fields = []

      context = %Context{
        repo: TestUser,
        query: query,
        fields: fields,
        args: %{age: 30},
        extra_fields: [:id],
        total_fn: total_fn
      }

      data = Query.get_list(context)
      assert is_list(data)
    end
  end

  defp repo_one(_), do: build(:user)
  defp repo_all(_), do: build_list(20, :user)
end
