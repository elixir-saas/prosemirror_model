defmodule ProsemirrorModel.Block.Heading do
  @moduledoc ~S"""
  Represents a heading (`<h1>...</h1>`).

  Contains multiple `ProsemirrorModel.Block.Text` and has attributes that
  define the level of the heading (between 1 and 6).

  ## Usage

      {:heading, levels}

  > `levels` is an array of allowed level (between 1 and 6).

  ## Examples

      {:heading, [1, 3]}

  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :heading

  alias ProsemirrorModel.Block

  @doc false
  embedded_schema do
    embeds_one(:attrs, __MODULE__.Attrs)

    embedded_prosemirror_content(
      [
        text: Block.Text
      ],
      extend: :heading,
      array: true
    )
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:attrs,
      with: &__MODULE__.Attrs.changeset(&1, &2, opts),
      required: true
    )
    |> cast_prosemirror_content(
      with:
        extend_prosemirror_changeset(:heading,
          default: [
            text: {Block.Text, :changeset, [opts]}
          ]
        )
    )
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, opts) do
      assigns = %{
        struct: struct,
        content: ProsemirrorModel.Encoder.HTML.encode(struct.content, opts)
      }

      ProsemirrorModel.EncoderHelpers.render(
        ~H"<.dynamic_tag name={~s'h#{@struct.attrs.level}'}><%= @content %></.dynamic_tag>"
      )
    end
  end

  ## Attrs

  defmodule __MODULE__.Attrs do
    @moduledoc false
    use ProsemirrorModel.Schema.Attrs

    embedded_schema do
      field(:level, :integer, default: 1)
    end

    def changeset(struct, attrs \\ %{}, opts \\ []) do
      struct
      |> Ecto.Changeset.cast(attrs, [:level])
      |> Ecto.Changeset.validate_required([:level])
      |> Ecto.Changeset.validate_inclusion(:level, opts[:level] || 1..6)
    end
  end
end
