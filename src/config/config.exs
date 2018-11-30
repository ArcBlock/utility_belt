use Mix.Config

config :cipher,
  runtime_phrases: true,
  keyphrase: "tyrtothemoon!",
  ivphrase: "tyrandthechamberofsecrets!"

import_config "#{Mix.env()}.exs"
