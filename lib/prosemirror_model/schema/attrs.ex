defmodule ProsemirrorModel.Schema.Attrs do
  @moduledoc ~S"""
  Module helper for `Ecto.Schema` for node and mark attrs.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @derive {Jason.Encoder, except: [:__struct__]}
      @primary_key false
    end
  end
end
