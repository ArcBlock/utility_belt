defmodule UtilityBelt.Plug.Metrics do
  @moduledoc """
  A plug for logging db metrics per request
  """
  require Logger

  alias ExDatadog.Plug.Statix
  alias Plug.Conn

  @behaviour Plug

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    app_prefix =
      :utility_belt |> Application.get_env(:metrics, prefix: "db") |> Access.get(:prefix)

    prefix = Access.get(opts, :prefix) || app_prefix

    Conn.register_before_send(conn, fn conn ->
      count = get_query_count()

      if count > 0 do
        Logger.info("Query Executed #{count} queries for #{conn.params["query"]}")
        send_metrics("#{prefix}.queries_per_request", count, get_tags())
      end

      conn
    end)
  end

  defp get_query_count do
    request_id = get_logger_data(:request_id)
    ConCache.get(:query_metrics, request_id) || 0
  end

  defp get_query_name, do: get_logger_data(:query)

  defp get_tags do
    case get_query_name() do
      nil -> []
      name -> [Atom.to_string(name)]
    end
  end

  defp send_metrics(_name, 0, _), do: nil
  defp send_metrics(name, value, tags), do: Statix.histogram(name, value, tags: tags)

  defp get_logger_data(key), do: Logger.metadata() |> Access.get(key)
end
