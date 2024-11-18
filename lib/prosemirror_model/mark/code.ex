defmodule ProsemirrorModel.Mark.Code do
  @moduledoc ~S"""
  Represents code in text (`<code>...</code>`).
  """
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :code

  @doc false
  embedded_schema(do: nil)

  @doc false
  def changeset(struct, attrs \\ %{}) do
    Ecto.Changeset.cast(struct, attrs, [])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(_struct, opts) do
      assigns = Map.new(opts)

      ProsemirrorModel.EncoderHelpers.render(~H"<code><%= @inner_content %></code>")
    end
  end
end
