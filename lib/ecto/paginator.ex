defmodule UtilityBelt.Ecto.Query.Paginator do
  @moduledoc """
  useful utility functions for GQL
  """
  require Logger

  def get_cursor(nil), do: {get_default_page(), 0}

  def get_cursor(args) do
    default_page_size = get_default_page()
    default_cursor = get_default_cursor()
    paging = Map.get(args, :paging, %{size: default_page_size, cursor: default_cursor})
    size = Map.get(paging, :size, default_page_size)

    size =
      case size > default_page_size do
        true -> default_page_size
        _ -> size
      end

    cursor =
      case paging |> Map.get(:cursor, default_cursor) |> Cipher.decrypt() do
        {:error, _} -> "0"
        v -> v
      end

    {size, String.to_integer(cursor)}
  end

  def get_info(data, total, cursor, size) do
    has_next = data != []

    cursor =
      case has_next do
        true -> Cipher.encrypt("#{cursor + size}")
        _ -> get_default_cursor()
      end

    %{
      total: total,
      next: has_next,
      cursor: cursor
    }
  end

  def get_info(total_fn, cursor, size) do
    total = total_fn.()
    has_next = total > cursor + size

    cursor =
      case has_next do
        true -> Cipher.encrypt("#{cursor + size}")
        _ -> get_default_cursor()
      end

    %{
      total: total,
      next: has_next,
      cursor: cursor
    }
  end

  def get_default_cursor,
    do: Application.get_env(:utility_belt, :default_cursor, Cipher.encrypt("0"))

  def get_default_page, do: Application.get_env(:utility_belt, :default_page_size, 10)
end
