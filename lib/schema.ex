defmodule ProsemirrorModel.Schema do
  @moduledoc ~S"""
  Module helper for Ecto.Schema.
  """

  @doc ~S"""
  Automatically imports ProsemirrorModel.Schema functions helper.

  ## Examples

      use ProsemirrorModel.Schema

  """
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @primary_key false
      import ProsemirrorModel.Schema, only: [prosemirror_field: 2]
    end
  end

  @doc ~S"""
  Helper to generate ProsemirrorModel ecto schema field.

  ## Examples

      schema "my_schema" do
        prosemirror_field :title, DocumentType
      end

      # Compiles to:

      field :title_plain, :string, virtual: true
      embeds_one :title, DocumentType

  """
  defmacro prosemirror_field(name, type) do
    quote do
      field(unquote(:"#{name}_plain"), :string, virtual: true)
      embeds_one(unquote(name), unquote(type), on_replace: :delete)
    end
  end
end
