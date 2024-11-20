defmodule ProsemirrorModel.Node.ListItem do
  @moduledoc ~S"""
  Represents a list item (`<li>...</li>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :listItem

  alias ProsemirrorModel.Node

  @doc false
  embedded_schema do
    embedded_prosemirror_content(
      [
        heading: Node.Heading,
        bulletList: Node.BulletList,
        orderedList: Node.OrderedList,
        paragraph: Node.Paragraph
      ],
      extend: :listItem,
      array: true
    )
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(
      with:
        extend_prosemirror_changeset(:listItem,
          default: [
            heading: {Node.Heading, :changeset, [opts]},
            bulletList: {Node.BulletList, :changeset, [opts]},
            orderedList: {Node.OrderedList, :changeset, [opts]},
            paragraph: {Node.Paragraph, :changeset, [opts]}
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

      ProsemirrorModel.EncoderHelpers.render(~H"<li><%= @content %></li>")
    end
  end
end
