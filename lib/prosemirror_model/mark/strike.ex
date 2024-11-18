defmodule ProsemirrorModel.Mark.Strike do
  @moduledoc ~S"""
  Represents strikethrough text (`<s>...</s>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :strike

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

      ProsemirrorModel.EncoderHelpers.render(~H"<s><%= @inner_content %></s>")
    end
  end
end
