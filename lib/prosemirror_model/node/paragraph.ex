defmodule ProsemirrorModel.Node.Paragraph do
  @moduledoc ~S"""
  Represents a paragraph (`<p>...</p>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :paragraph

  alias ProsemirrorModel.Node

  @doc false
  embedded_schema do
    embedded_prosemirror_content(
      [
        bulletList: Node.BulletList,
        hardBreak: Node.HardBreak,
        orderedList: Node.OrderedList,
        text: Node.Text
      ],
      extend: :paragraph,
      array: true
    )
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(
      with:
        extend_prosemirror_changeset(:paragraph,
          default: [
            bulletList: {Node.BulletList, :changeset, [opts]},
            hardBreak: {Node.HardBreak, :changeset, [opts]},
            orderedList: {Node.OrderedList, :changeset, [opts]},
            text: {Node.Text, :changeset, [opts]}
          ]
        )
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
