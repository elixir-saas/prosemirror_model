defmodule ProsemirrorModel.TypeTest do
  use ExUnit.Case

  alias ProsemirrorModel.Block
  alias ProsemirrorModel.TestType

  test "casts data to generated type struct" do
    attrs = %{
      type: "doc",
      content: [
        %{
          type: "heading",
          attrs: %{level: 1},
          content: [%{type: "text", text: "heading"}]
        },
        %{
          type: "paragraph",
          content: [%{type: "text", text: "hello world"}]
        }
      ]
    }

    expected = %TestType{
      type: "doc",
      content: [
        %Block.Heading{
          attrs: %Block.Heading.Attrs{level: 1},
          content: [%Block.Text{text: "heading"}]
        },
        %Block.Paragraph{
          content: [%Block.Text{text: "hello world"}]
        }
      ]
    }

    data =
      %TestType{}
      |> TestType.changeset(attrs)
      |> Ecto.Changeset.apply_changes()

    assert ^expected = data
  end
end
