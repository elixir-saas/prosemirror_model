defmodule ProsemirrorModel.Mark.Link do
  @moduledoc ~S"""
  Represents linked text (`<a href="...">...</a>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :link

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
      default_link_opts = %{rel: nil, target: nil}

      assigns =
        default_link_opts
        |> Map.merge(Map.new(opts[:link_opts] || %{}))
        |> Map.put(:struct, struct)
        |> Map.put(:inner_content, opts[:inner_content])

      ProsemirrorModel.EncoderHelpers.render(
        ~H"<a href={@struct.attrs.href} rel={@rel} target={@target}><%= @inner_content %></a>"
      )
    end
  end

  ## Attrs

  defmodule __MODULE__.Attrs do
    @moduledoc false
    use ProsemirrorModel.Schema.Attrs

    embedded_schema do
      field(:href, :string)
    end

    def changeset(struct, attrs \\ %{}) do
      struct
      |> Ecto.Changeset.cast(attrs, [:href])
      |> Ecto.Changeset.validate_required([:href])
    end
  end
end
