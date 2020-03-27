# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :core_banking, CoreBanking.Repo,
  database: "core_banking",
  username: "postgres",
  password: "root",
  hostname: "db",
  pool_size: 50,
  queue_target: 5_000,
  queue_interval: 10_000

