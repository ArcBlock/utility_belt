defmodule UtilityBelt.Jwt do
  @moduledoc """
  Json web token support
  """

  [:hs256, :hs384, :hs512]
  |> Enum.map(fn method ->
    encode_name = :"encode_#{method}"
    decode_name = :"decode_#{method}"

    def unquote(encode_name)(data, secret, opts \\ [exp: 86_400]) do
      exp = Access.get(opts, :exp)
      signer = apply(Joken, unquote(method), [secret])

      data
      |> Joken.token()
      |> with_exp_seconds(exp)
      |> Joken.with_signer(signer)
      |> Joken.sign()
      |> Joken.get_compact()
    end

    def unquote(decode_name)(signed_token, secret) do
      signer = apply(Joken, unquote(method), [secret])

      signed_token
      |> Joken.token()
      |> Joken.with_signer(signer)
      |> Joken.verify()
      |> Joken.get_claims()
      |> valid_claim()
    end
  end)

  defp with_exp_seconds(t, nil), do: t

  defp with_exp_seconds(t, v) do
    Joken.with_claim_generator(t, "exp", fn ->
      Joken.current_time() + v
    end)
  end

  defp valid_claim(%{"exp" => exp} = t) do
    case exp > Joken.current_time() do
      true -> Map.delete(t, "exp")
      _ -> %{}
    end
  end

  defp valid_claim(t), do: t
end
