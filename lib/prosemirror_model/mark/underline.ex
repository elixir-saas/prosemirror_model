defmodule ProsemirrorModel.Mark.Underline do
  @moduledoc ~S"""
  Represents underlined text (`<u>...</u>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :underline

  @doc false
  embedded_schema(do: nil)

  @doc false
  def changeset(struct, attrs \\ %{}) do
    Ecto.Changeset.cast(struct, attrs, [])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(_struct, opts) do
      assigns = Map.new(opts)

      ProsemirrorModel.EncoderHelpers.render(~H"<u><%= @inner_content %></u>")
    end
  end
end
