defmodule ProsemirrorModel.Mark.Italic do
  @moduledoc ~S"""
  Represents italic text (`<em>...</em>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :italic

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

      ProsemirrorModel.EncoderHelpers.render(~H"<em><%= @inner_content %></em>")
    end
  end
end
