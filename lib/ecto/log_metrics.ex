defmodule UtilityBelt.Ecto.Metrics do
  @moduledoc """
  DB Metrics for datadog. Make sure you add this to your config:

  config :utility_belt, :metrics,
  	prefix: "your-prefix"

  	config :your_app, Repo,
  		adapter: Postgres,
  		loggers: [{UtilityBelt.Ecto.Metrics, :send_metric, []}]
  """
  require Logger
  alias ExDatadog.Plug.Statix

  def send_metric(entry) do
    request_id = get_logger_data(:request_id)
    query_name = get_logger_data(:query)

    count = ConCache.get(:query_metrics, request_id) || 0
    ConCache.put(:query_metrics, request_id, count + 1)

    {status, result} = entry.result

    source = entry.source

    prefix = :utility_belt |> Application.get_env(:metrics, prefix: source) |> Access.get(:prefix)

    tags =
      case query_name do
        nil -> [source, Atom.to_string(status)]
        _ -> [source, Atom.to_string(status), Atom.to_string(query_name)]
      end

    case status do
      :ok -> Statix.gauge("#{prefix}.query_num_rows", result.num_rows)
      _ -> nil
    end

    queue_time = convert_time(entry.queue_time)
    query_time = convert_time(entry.query_time) + queue_time

    Statix.increment("#{prefix}.query_executed")
    Statix.histogram("#{prefix}.query_time", query_time, tags: tags)
    Statix.histogram("#{prefix}.query_queue_time", queue_time, tags: tags)

    Logger.info(
      "Query #{query_name} (#{entry.source}) total time: #{query_time}ms, queue time: #{
        queue_time
      }ms. Execute status: #{status}. Query: #{entry.query}. Params: #{inspect(entry.params)} "
    )
  end

  defp convert_time(time) do
    System.convert_time_unit(time || 0, :native, :milli_seconds)
  end

  defp get_logger_data(key), do: Logger.metadata() |> Access.get(key)
end
