defmodule UtilityBelt.Application do
  @moduledoc false

  use Application
  alias UtilityBelt.Config

  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: UtilityBelt.Supervisor]

    update_runtime_config()

    Supervisor.start_link(children, opts)
  end

  def update_runtime_config do
    Config.update(:cipher, :keyphrase, System.get_env("CIPHER_KEY_PHRASE"))
    Config.update(:cipher, :ivphrase, System.get_env("CIPHER_IV_PHRASE"))
  end
end
