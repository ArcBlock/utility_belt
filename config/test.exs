use Mix.Config

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :bcrypt_elixir, log_rounds: 4
config :pbkdf2_elixir, rounds: 1
