defmodule ProsemirrorModel.Block.Paragraph do
  @moduledoc ~S"""
  Represents a paragraph (`<p>...</p>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :paragraph

  alias ProsemirrorModel.Block

  @doc false
  embedded_schema do
    embedded_prosemirror_content(
      [
        bulletList: Block.BulletList,
        hardBreak: Block.HardBreak,
        orderedList: Block.OrderedList,
        text: Block.Text
      ],
      array: true
    )
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(
      with: [
        bulletList: {Block.BulletList, :changeset, [opts]},
        hardBreak: {Block.HardBreak, :changeset, [opts]},
        orderedList: {Block.OrderedList, :changeset, [opts]},
        text: {Block.Text, :changeset, [opts]}
      ]
    )
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, opts) do
      assigns = %{
        content: ProsemirrorModel.Encoder.HTML.encode(struct.content, opts)
      }

      ProsemirrorModel.EncoderHelpers.render(~H"<p><%= @content %></p>")
    end
  end
end
