defmodule UtilityBelt.Absinthe.Selection do
  @moduledoc """
  useful utility functions for GQL
  """
  require Logger

  def clean_fields(fields, exclude \\ []) do
    exclude = [:typename | exclude]

    {raw, complex} =
      fields
      |> Enum.split_with(&is_atom/1)

    {raw -- exclude, complex}
  end

  def parse_info(info) do
    name = normalize_query_name(info.definition.name)
    fields = get_selections(info.definition.selections)

    {name, fields}
  end

  def get_selections(selections) do
    result =
      Enum.map(selections, fn item ->
        name = item |> Map.get(:name) |> Recase.to_snake() |> String.to_atom()

        case Map.get(item, :selections) do
          nil -> name
          [] -> name
          _ -> nil
        end
      end)

    (result -- [:typename]) |> Enum.reject(&is_nil/1)
  end

  def get_selections(selections, :nested) do
    selections
    |> Enum.map(fn item ->
      name = item |> Map.get(:name) |> Recase.to_snake() |> String.to_atom()

      case Map.get(item, :selections) do
        nil -> name
        [] -> name
        inner_selections -> {name, get_selections(inner_selections)}
      end
    end)
  end

  def normalize_query_name(name), do: name |> Recase.to_snake() |> String.to_existing_atom()
end
