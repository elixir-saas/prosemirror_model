defmodule ProsemirrorModel.Block.HorizontalRule do
  @moduledoc ~S"""
  Represents a horizontal rule (`<hr />`).
  """
  use ProsemirrorModel
  use ProsemirrorModel.Schema
  use ProsemirrorModel.Encoder.JSON, type: :horizontalRule

  @doc false
  embedded_schema do
    embedded_prosemirror_marks()
  end

  @doc false
  def changeset(struct, attrs \\ %{}, opts \\ []) do
    allowed_marks =
      opts
      |> Keyword.get(:marks, [])
      |> Enum.map(&elem(&1, 1))

    struct
    |> Ecto.Changeset.cast(attrs, [])
    |> cast_prosemirror_marks()
    |> filter_marks(allowed_marks)
  end

  defp filter_marks(changeset, allowed_marks) do
    Ecto.Changeset.update_change(changeset, :marks, fn marks ->
      Enum.filter(marks, &Enum.member?(allowed_marks, &1.__struct__))
    end)
  end

  defimpl ProsemirrorModel.Encoder.HTML do
    use Phoenix.Component

    def encode(_struct, _opts) do
      assigns = %{}
      ProsemirrorModel.EncoderHelpers.render(~H"<hr />")
    end
  end
end
