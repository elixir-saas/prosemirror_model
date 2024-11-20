defmodule ProsemirrorModel.Node.Blockquote do
  @moduledoc ~S"""
  Represents a blockquote (`<blockquote>...</blockquote>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :blockquote

  alias ProsemirrorModel.Node

  @doc false
  embedded_schema do
    embedded_prosemirror_content(
      [
        codeBlock: Node.CodeBlock,
        blockquote: __MODULE__,
        bulletList: Node.BulletList,
        orderedList: Node.OrderedList,
        paragraph: Node.Paragraph
      ],
      extend: :blockquote,
      array: true
    )
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(
      with:
        extend_prosemirror_changeset(:blockquote,
          default: [
            codeBlock: {Node.CodeBlock, :changeset, [opts]},
            blockquote: {__MODULE__, :changeset, [opts]},
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

      ProsemirrorModel.EncoderHelpers.render(~H"<blockquote><%= @content %></blockquote>")
    end
  end
end
