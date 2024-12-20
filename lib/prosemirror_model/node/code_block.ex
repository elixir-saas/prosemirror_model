defmodule ProsemirrorModel.Node.CodeBlock do
  @moduledoc """
  Represents a code block (`<pre>...</pre>`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :codeBlock

  alias ProsemirrorModel.Node

  @doc false
  embedded_schema do
    embedded_prosemirror_content([text: Node.Text], extend: false, array: true)
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_content(with: [text: {Node.Text, :changeset, [opts]}])
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
