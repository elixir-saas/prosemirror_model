defmodule ProsemirrorModel.Block.Blockquote do
  @moduledoc ~S"""
  Represents a blockquote (`<blockquote>...</blockquote>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :blockquote

  alias ProsemirrorModel.Block

  @doc false
  embedded_schema do
    embedded_prosemirror_content(
      [
        codeBlock: Block.CodeBlock,
        blockquote: __MODULE__,
        bulletList: Block.BulletList,
        orderedList: Block.OrderedList,
        paragraph: Block.Paragraph
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
        codeBlock: {Block.CodeBlock, :changeset, [opts]},
        blockquote: {__MODULE__, :changeset, [opts]},
        bulletList: {Block.BulletList, :changeset, [opts]},
        orderedList: {Block.OrderedList, :changeset, [opts]},
        paragraph: {Block.Paragraph, :changeset, [opts]}
      ]
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
