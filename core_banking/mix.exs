defmodule CoreBankingUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      version: "0.1.0",
      default_release: :prod,
      releases: [
        prod: [
          include_executables_for: [:unix],
          applications: [
            core_banking: :permanent,
            core_banking_server: :permanent
          ]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end
end
