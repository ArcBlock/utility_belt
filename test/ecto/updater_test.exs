defmodule UtilityBelt.UpdaterTest do
  @moduledoc false
  use ExUnit.Case

  import Mock

  alias UtilityBelt.Db.Repo
  alias UtilityBelt.Db.Schema.User
  alias UtilityBelt.Ecto.{UpdateContext, Updater}

  test "simple insert" do
    with_mock(Repo, insert: &repo_insert/1) do
      context = %UpdateContext{
        repo: Repo,
        schema: User,
        data: %{id: "1234", username: "tyr"}
      }

      {:ok, data} = Updater.insert(context)
      assert !is_nil(data.id)

      context = %UpdateContext{
        repo: Repo,
        schema: User,
        data: %{id: "1234"}
      }

      assert {:error, _} = Updater.insert(context)
    end
  end

  test "simple upsert" do
    with_mock(Repo, insert: &repo_insert/2) do
      context = %UpdateContext{
        repo: Repo,
        schema: User,
        data: %{id: "1234", username: "tyr"}
      }

      {:ok, data} = Updater.upsert(context, on_conflict: :nothing, conflict_target: :email)
      assert !is_nil(data.id)
    end
  end

  test "simple update" do
    with_mock(Repo, update: &repo_update/1, get_by: &reo_get_by/2) do
      context = %UpdateContext{
        repo: Repo,
        schema: User,
        data: %{id: "1234", username: "tyr"}
      }

      {:ok, data} = Updater.update(context)
      assert !is_nil(data.id)
    end
  end

  test "simple delete" do
    with_mock(Repo, delete: &repo_delete/1) do
      context = %UpdateContext{
        repo: Repo,
        schema: User,
        data: %{id: "1234", username: "tyr"}
      }

      {:ok, data} = Updater.delete(context)
      assert !is_nil(data.id)
    end
  end

  defp repo_insert(changeset), do: {:ok, changeset.changes}
  defp repo_insert(changeset, _opts), do: {:ok, changeset.changes}
  defp repo_update(changeset), do: {:ok, changeset.changes}
  defp repo_delete(changeset), do: {:ok, changeset.changes}
  def reo_get_by(_schema, _opts), do: %User{id: 1, username: "tyr"}
end
