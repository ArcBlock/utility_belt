defmodule UtilityBelt.Password do
  @moduledoc """
  Use string password algorithm (Argon2 or Bcrypt) to encrypt(hash) the password. Argon2 is newer, stronger (use lots of memory to reduce the risk for GPU brutal force), Bcrypt is more matural and be considered as the most secure algo in past 15 years.
  """

  @prefix "Elixir.Comeonin"

  ["Argon2", "Bcrypt"]
  |> Enum.map(fn name ->
    mod = String.to_existing_atom("#{@prefix}.#{name}")
    new_name = String.downcase(name)
    enc_name = String.to_atom("encrypt_#{new_name}")
    check_name = String.to_atom("check_#{new_name}")

    def unquote(enc_name)(password) do
      apply(unquote(mod), :hashpwsalt, [password])
    end

    def unquote(check_name)(password, encrypted_password) do
      apply(unquote(mod), :checkpw, [password, encrypted_password])
    end
  end)
end
