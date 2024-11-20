defmodule ProsemirrorModel.DocumentTest do
  use ExUnit.Case

  alias ProsemirrorModel.Node
  alias ProsemirrorModel.TestDocument

  test "casts data to generated document struct" do
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

    expected = %TestDocument{
      type: "doc",
      content: [
        %Node.Heading{
          attrs: %Node.Heading.Attrs{level: 1},
          content: [%Node.Text{text: "heading"}]
        },
        %Node.Paragraph{
          content: [%Node.Text{text: "hello world"}]
        }
      ]
    }

    data =
      %TestDocument{}
      |> TestDocument.changeset(attrs)
      |> Ecto.Changeset.apply_changes()

    assert ^expected = data
  end

  test "extends a node with another content node" do
    attrs = %{
      type: "doc",
      content: [
        %{
          type: "paragraph",
          content: [
            %{type: "text", text: "hello world"},
            %{type: "image", attrs: %{src: "https://example.com"}}
          ]
        }
      ]
    }

    expected = %TestDocument{
      type: "doc",
      content: [
        %Node.Paragraph{
          content: [
            %Node.Text{text: "hello world"},
            %Node.Image{attrs: %Node.Image.Attrs{src: "https://example.com"}}
          ]
        }
      ]
    }

    data =
      %TestDocument{}
      |> TestDocument.changeset(attrs)
      |> Ecto.Changeset.apply_changes()

    assert ^expected = data
  end
end
