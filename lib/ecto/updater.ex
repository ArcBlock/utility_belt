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
    case context.query do
      nil ->
        process_one(context, type)

      _ ->
        case process_many(context, type) do
          {:error, error} -> {:error, encode_changeset_error(error.errors)}
          result -> result
        end
    end
  end

  defp process_one(context, type) do
    data = context.data
    schema = context.schema

    changeset =
      case type in [:insert, :upsert] do
        true -> schema.insert_changeset(data)
        _ -> schema.update_changeset(data)
      end

    context = %{context | changeset: changeset}

    case changeset.valid? do
      true ->
        case execute_one(context, type) do
          {:error, cs} -> {:error, encode_changeset_error(cs.errors)}
          result -> result
        end

      _ ->
        {:error, encode_changeset_error(changeset.errors)}
    end
  end

  defp process_many(context, :update) do
    context.repo.update_all(context.query, context.data, returning: context.fields || true)
  end

  defp process_many(context, :insert) do
    context.repo.insert_all(context.query, context.data)
  end

  defp process_many(context, :upsert) do
    context.repo.insert_all(context.query, context.data, context.opts)
  end

  defp process_many(context, :delete) do
    context.repo.delete_all(context.query, context.data, returning: context.fields || true)
  end

  defp execute_one(context, :insert) do
    context.repo.insert(context.changeset)
  end

  defp execute_one(context, :upsert) do
    context.repo.insert(context.changeset, context.opts)
  end

  defp execute_one(context, :update) do
    repo = context.repo
    pk_fields = Access.get(context.opts, :pk)

    case repo.get_by(context.schema, pk_fields) do
      nil ->
        {:error, "cannot find data matches #{inspect(pk_fields)}"}

      data ->
        changeset = context.schema.update_changeset(context.data, data)
        repo.update(changeset)
    end
  end

  defp execute_one(context, :delete) do
    context.repo.delete(context.changeset)
  end

  defp encode_changeset_error(error) do
    %{message: inspect(error)}
  end
end
