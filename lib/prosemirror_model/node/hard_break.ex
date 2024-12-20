defmodule ProsemirrorModel.Node.HardBreak do
  @moduledoc """
  Represents a hard break (`<br>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :hardBreak

  embedded_schema(do: nil)

  def changeset(struct, attrs \\ %{}, _opts \\ []) do
    Ecto.Changeset.cast(struct, attrs, [])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(_struct, _opts) do
      assigns = %{}
      ProsemirrorModel.EncoderHelpers.render(~H"<br />")
    end
  end
end
