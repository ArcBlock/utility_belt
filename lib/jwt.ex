defmodule UtilityBelt.Jwt do
  @moduledoc """
  Json web token support
  """
  import Joken

  [:hs256, :hs384, :hs512]
  |> Enum.map(fn method ->
    encode_name = :"encode_#{method}"
    decode_name = :"decode_#{method}"

    def unquote(encode_name)(data, secret, opts \\ [exp: 86_400]) do
      exp = Access.get(opts, :exp)
      signer = apply(Joken, unquote(method), [secret])
      data |> token |> with_exp_seconds(exp) |> with_signer(signer) |> sign |> get_compact
    end

    def unquote(decode_name)(signed_token, secret) do
      signer = apply(Joken, unquote(method), [secret])
      signed_token |> token |> with_signer(signer) |> verify |> get_claims |> valid_claim
    end
  end)

  defp with_exp_seconds(t, nil), do: t

  defp with_exp_seconds(t, v),
    do: with_claim_generator(t, "exp", fn -> current_time() + v end)

  defp valid_claim(%{"exp" => exp} = t) do
    case exp > current_time() do
      true -> Map.delete(t, "exp")
      _ -> %{}
    end
  end

  defp valid_claim(t), do: t
end
