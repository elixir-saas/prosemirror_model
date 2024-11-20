defmodule ProsemirrorModel.Node.OrderedList do
  @moduledoc """
  Represents an ordered list (`<ol>...</ol>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :orderedList

  alias ProsemirrorModel.Node

  @doc false
  embedded_schema do
    embeds_one(:attrs, __MODULE__.Attrs)
    embedded_prosemirror_content([listItem: Node.ListItem], extend: false, array: true)
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:attrs, required: false)
    |> cast_prosemirror_content(with: [listItem: {Node.ListItem, :changeset, [opts]}])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, opts) do
      assigns = %{
        struct: struct,
        content: ProsemirrorModel.Encoder.HTML.encode(struct.content, opts)
      }

      ProsemirrorModel.EncoderHelpers.render(
        ~H"<ol start={@struct.attrs.start}><%= @content %></ol>"
      )
    end
  end

  ## Attrs

  defmodule __MODULE__.Attrs do
    use ProsemirrorModel.Schema.Attrs

    embedded_schema do
      field(:start, :integer)
    end

    def changeset(struct, attrs \\ %{}) do
      Ecto.Changeset.cast(struct, attrs, [:start])
    end
  end
end
