defmodule ProsemirrorModel.Block.HardBreak do
  @moduledoc """
  Representation of a hard break tag (`<br>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :hard_break

  embedded_schema(do: nil)

  def changeset(struct, attrs \\ %{}) do
    Ecto.Changeset.cast(struct, attrs, [])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(_struct, _opts) do
      assigns = %{}
      ~H"<br />"
    end
  end
end
