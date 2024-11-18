defmodule ProsemirrorModel.Mark.Color do
  @moduledoc ~S"""
  Represents colored text (`<span style="color: ...;">...</span>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :color

  @doc false
  embedded_schema do
    embeds_one(:attrs, __MODULE__.Attrs)
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:attrs, required: true)
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, opts) do
      assigns = %{
        struct: struct,
        inner_content: opts[:inner_content]
      }

      ProsemirrorModel.EncoderHelpers.render(
        ~H"<span style={~s'color: #{@struct.attrs.color};'}><%= @inner_content %></span>"
      )
    end
  end

  ## Attrs

  defmodule __MODULE__.Attrs do
    @moduledoc false
    use ProsemirrorModel.Schema.Attrs

    embedded_schema do
      field(:color, :string)
    end

    def changeset(struct, attrs \\ %{}) do
      struct
      |> Ecto.Changeset.cast(attrs, [:color])
      |> Ecto.Changeset.validate_required([:color])
    end
  end
end
