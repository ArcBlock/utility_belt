defmodule PasswordTest do
  use ExUnit.Case
  alias UtilityBelt.Password

  @password "tyrchen"

  ["argon2", "bcrypt"]
  |> Enum.map(fn name ->
    enc_name = String.to_atom("encrypt_#{name}")
    check_name = String.to_atom("check_#{name}")

    test "#{name} should work" do
      p = apply(Password, unquote(enc_name), [unquote(@password)])
      assert true == apply(Password, unquote(check_name), [unquote(@password), p])
    end

    test "#{name} should not work for bad password" do
      p = apply(Password, unquote(enc_name), [unquote(@password) <> "1234"])
      assert false == apply(Password, unquote(check_name), [unquote(@password), p])
    end
  end)
end
