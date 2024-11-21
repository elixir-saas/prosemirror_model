defmodule ProsemirrorModel.DocumentTest do
  use ExUnit.Case

  alias ProsemirrorModel.Document
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

  describe "trim/1" do
    test "trims leading and trailing whitespace" do
      document = %TestDocument{
        type: "doc",
        content: [
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 1   "}]},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 2   "}]},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 3   "}]}
        ]
      }

      expected = %TestDocument{
        type: "doc",
        content: [
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 1   "}]},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 2   "}]},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 3"}]}
        ]
      }

      assert ^expected = Document.trim(document)
    end

    test "ignores non-text nodes" do
      document = %TestDocument{
        type: "doc",
        content: [
          %Node.HorizontalRule{},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 1   "}]},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 2   "}]},
          %Node.Paragraph{content: [%Node.Text{text: "   paragraph 3   "}]},
          %Node.HorizontalRule{}
        ]
      }

      assert ^document = Document.trim(document)
    end
  end

  describe "update_leading_node/2" do
    test "updates only the leading node" do
      document = %TestDocument{
        type: "doc",
        content: [
          %Node.Heading{
            attrs: %Node.Heading.Attrs{level: 1},
            content: [%Node.Text{text: "heading"}]
          },
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 1"}]},
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 2"}]}
        ]
      }

      expected = %TestDocument{
        type: "doc",
        content: [
          %Node.Heading{
            attrs: %Node.Heading.Attrs{level: 1},
            content: [%Node.Text{text: "HEADING"}]
          },
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 1"}]},
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 2"}]}
        ]
      }

      assert ^expected =
               Document.update_leading_node(document, fn text ->
                 %{text | text: String.upcase(text.text)}
               end)
    end
  end

  describe "update_trailing_node/2" do
    test "updates only the trailing node" do
      document = %TestDocument{
        type: "doc",
        content: [
          %Node.Heading{
            attrs: %Node.Heading.Attrs{level: 1},
            content: [%Node.Text{text: "heading"}]
          },
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 1"}]},
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 2"}]}
        ]
      }

      expected = %TestDocument{
        type: "doc",
        content: [
          %Node.Heading{
            attrs: %Node.Heading.Attrs{level: 1},
            content: [%Node.Text{text: "heading"}]
          },
          %Node.Paragraph{content: [%Node.Text{text: "paragraph 1"}]},
          %Node.Paragraph{content: [%Node.Text{text: "PARAGRAPH 2"}]}
        ]
      }

      assert ^expected =
               Document.update_trailing_node(document, fn text ->
                 %{text | text: String.upcase(text.text)}
               end)
    end
  end

  describe "update_text/2" do
    test "updates a text node" do
      struct = %Node.Text{text: "some text"}
      expected = %Node.Text{text: "SOME TEXT"}

      assert ^expected = Document.update_text(struct, &String.upcase/1)
    end

    test "ignores a non-text node" do
      struct = %Node.HorizontalRule{}

      assert ^struct = Document.update_text(struct, &String.upcase/1)
    end
  end
end
