defmodule UtilityBelt.Ecto.Updater do
  @moduledoc """
   Helper functions to update database
  """

  def insert(context), do: process(context, :insert)

  def upsert(context, opts) do
    new_opts = Keyword.merge(context.opts || [], opts || [])
    process(%{context | opts: new_opts}, :upsert)
  end

  def update(context), do: process(context, :update)
  def delete(context), do: process(context, :delete)

  defp process(context, type) do
    data = context.data
    schema = context.schema
    changeset = schema.changeset(data)
    context = %{context | changeset: changeset}

    case changeset.valid? do
      true -> execute(context, type)
      _ -> {:error, changeset.errors}
    end
  end

  defp execute(context, :insert) do
    context.repo.insert(context.changeset)
  end

  defp execute(context, :upsert) do
    opts = context.opts

    context.repo.insert(
      context.changeset,
      on_conflict: Access.get(opts, :on_conflict),
      conflict_target: Access.get(opts, :conflict_target)
    )
  end

  defp execute(context, :update) do
    context.repo.update(context.changeset)
  end

  defp execute(context, :delete) do
    context.repo.delete(context.changeset)
  end
end
