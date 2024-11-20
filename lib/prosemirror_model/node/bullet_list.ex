defmodule ProsemirrorModel.Node.BulletList do
  @moduledoc """
  Represents a bullet list (`<ul>...</ul>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :bulletList

  alias ProsemirrorModel.Node

  @doc false
  embedded_schema do
    embedded_prosemirror_content([listItem: Node.ListItem], extend: false, array: true)
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(with: [listItem: {Node.ListItem, :changeset, [opts]}])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, opts) do
      assigns = %{
        content: ProsemirrorModel.Encoder.HTML.encode(struct.content, opts)
      }

      ProsemirrorModel.EncoderHelpers.render(~H"<ul><%= @content %></ul>")
    end
  end
end
