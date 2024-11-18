defmodule ProsemirrorModel.Block.CodeBlock do
  @moduledoc """
  Represents a code block (`<pre>...</pre>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :codeBlock

  alias ProsemirrorModel.Block

  @doc false
  embedded_schema do
    embedded_prosemirror_content([text: Block.Text], array: true)
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(with: [text: {Block.Text, :changeset, [opts]}])
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(struct, opts) do
      assigns = %{
        content: ProsemirrorModel.Encoder.HTML.encode(struct.content, opts)
      }

      ProsemirrorModel.EncoderHelpers.render(
        ~H"<pre><code :for={inner <- @content}><%= inner %></code></pre>"
      )
    end
  end
end
