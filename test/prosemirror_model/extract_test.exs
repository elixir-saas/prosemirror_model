defmodule ProsemirrorModel.ExtractTest do
  use ExUnit.Case

  alias ProsemirrorModel.Node

  describe "extract_text/1" do
    test "extracts text from a heading" do
      document =
        %Node.Heading{
          attrs: %Node.Heading.Attrs{level: 1},
          content: [
            %Node.Text{text: "hello"},
            %Node.Text{text: "world"}
          ]
        }

      assert ["hello", "world"] = ProsemirrorModel.Extract.extract_text(document)
    end

    test "extracts text from nested nodes" do
      document =
        %{
          content: [
            %Node.Heading{
              attrs: %Node.Heading.Attrs{level: 1},
              content: [%Node.Text{text: "hello"}]
            },
            %Node.Paragraph{
              content: [
                %Node.OrderedList{
                  content: [
                    %Node.ListItem{
                      content: [%Node.Text{text: "nested"}]
                    }
                  ]
                },
                %Node.Text{text: "text"}
              ]
            }
          ]
        }

      assert ["hello", "nested", "text"] = ProsemirrorModel.Extract.extract_text(document)
    end
  end

  describe "extract_nodes/2" do
    test "extracts headings" do
      document =
        %{
          content: [
            %Node.Paragraph{
              content: [
                %Node.Heading{
                  attrs: %Node.Heading.Attrs{level: 1},
                  content: [%Node.Text{text: "h1"}]
                },
                %Node.Text{text: "Heading"}
              ]
            },
            %Node.Paragraph{
              content: [
                %Node.Text{text: "Some leading text"},
                %Node.Heading{
                  attrs: %Node.Heading.Attrs{level: 2},
                  content: [%Node.Text{text: "h2"}]
                }
              ]
            }
          ]
        }

      headings = [
        %Node.Heading{attrs: %Node.Heading.Attrs{level: 1}, content: [%Node.Text{text: "h1"}]},
        %Node.Heading{attrs: %Node.Heading.Attrs{level: 2}, content: [%Node.Text{text: "h2"}]}
      ]

      assert ^headings = ProsemirrorModel.Extract.extract_nodes(document, Node.Heading)
    end
  end
end
