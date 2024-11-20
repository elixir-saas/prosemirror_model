defmodule ProsemirrorModel.Node.Text do
  @moduledoc """
  Represents inline text. Contained in most nodes, but not in the top level document.

  When creating an `ProsemirrorModel` node you can use this module with:

      embedded_prosemirror_content([text: ProsemirrorModel.Node.Text], array: true)

  You can also set the `:array` option to `false` if you want to inline the node.

  > The macro `embedded_prosemirror_content` is imported by using `ProsemirrorModel`.
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :text

  @doc false
  embedded_schema do
    field(:text, :string)
    embedded_prosemirror_marks()
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    allowed_marks =
      opts
      |> Keyword.get(:marks, [])
      |> Enum.map(&elem(&1, 1))

    struct
    |> Ecto.Changeset.cast(attrs, [:text])
    |> cast_prosemirror_marks()
    |> filter_marks(allowed_marks)
  end

  defp filter_marks(changeset, allowed_marks) do
    Ecto.Changeset.update_change(changeset, :marks, fn marks ->
      Enum.filter(marks, &Enum.member?(allowed_marks, &1.__struct__))
    end)
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    def encode(struct, opts) do
      text = Phoenix.HTML.html_escape(struct.text)

      struct.marks
      |> Enum.reverse()
      |> Enum.reduce(text, fn mark, inner ->
        ProsemirrorModel.Encoder.HTML.encode(mark, Keyword.put(opts, :inner_content, inner))
      end)
    end
  end
end
