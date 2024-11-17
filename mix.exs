defmodule ProsemirrorModel.MixProject do
  use Mix.Project

  def project do
    [
      app: :prosemirror_model,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.12"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 0.20"},
      {:polymorphic_embed, "~> 5.0"}
    ]
  end
end
