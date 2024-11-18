defmodule ProsemirrorModel.Mark.Bold do
  @moduledoc ~S"""
  Represents bold text (`<b>...</b>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :bold

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

      ProsemirrorModel.EncoderHelpers.render(~H"<strong><%= @inner_content %></strong>")
    end
  end
end
