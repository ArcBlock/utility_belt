defmodule JwtTest do
  use ExUnit.Case

  alias UtilityBelt.Jwt

  @data %{"user_id" => 1, "age" => 19}
  @secret "tyrchen"

  test "jwt encoded data could be decoded" do
    encoded = Jwt.encode_hs256(@data, @secret)
    assert @data == Jwt.decode_hs256(encoded, @secret)
  end

  test "jwt encoded data could not be decoded with bad secret" do
    encoded = Jwt.encode_hs256(@data, @secret <> "1234")
    assert %{} == Jwt.decode_hs256(encoded, @secret)
  end

  test "jwt encoded data could not be decoded if expired" do
    encoded = Jwt.encode_hs256(@data, @secret, exp: 1)
    :timer.sleep(1001)
    assert %{} == Jwt.decode_hs256(encoded, @secret)
  end
end
