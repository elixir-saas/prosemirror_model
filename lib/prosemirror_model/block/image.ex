defmodule ProsemirrorModel.Block.Image do
  @moduledoc ~S"""
  Represents an image (`<img />`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :image

  @doc false
  embedded_schema do
    embeds_one(:attrs, __MODULE__.Attrs)
  end

  @doc false
  def changeset(struct, attrs \\ %{}, _opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:attrs, required: true)
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, _opts) do
      assigns = Map.from_struct(struct.attrs)

      ProsemirrorModel.EncoderHelpers.render(~H"<img alt={@alt} src={@src} title={@title} />")
    end
  end

  ## Attrs

  defmodule __MODULE__.Attrs do
    @moduledoc false
    use ProsemirrorModel.Schema.Attrs

    @doc false
    embedded_schema do
      field(:alt, :string)
      field(:src, :string)
      field(:title, :string)
    end

    @doc false
    def changeset(struct, attrs \\ %{}) do
      struct
      |> Ecto.Changeset.cast(attrs, [:alt, :src, :title])
      |> Ecto.Changeset.validate_required([:src])
    end
  end
end
