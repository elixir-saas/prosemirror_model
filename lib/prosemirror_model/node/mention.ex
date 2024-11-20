defmodule ProsemirrorModel.Node.Mention do
  @moduledoc ~S"""
  Represents a mention (`<span class="mention">...</span>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :mention

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

    def encode(struct, opts) do
      label =
        if fun = opts[:encode_mention] do
          fun.(struct.attrs.id)
        else
          struct.attrs.label
        end

      assigns = %{id: struct.attrs.id, label: label}

      ProsemirrorModel.EncoderHelpers.render(
        ~H"<span id={@id} label={@label} class='mention'><%= @label %></span>"
      )
    end
  end

  ## Attrs

  defmodule __MODULE__.Attrs do
    @moduledoc false
    use ProsemirrorModel.Schema.Attrs

    embedded_schema do
      field(:id, :string)
      field(:label, :string)
    end

    def changeset(struct, attrs \\ %{}) do
      struct
      |> Ecto.Changeset.cast(attrs, [:id, :label])
      |> Ecto.Changeset.validate_required([:id])
    end
  end
end
