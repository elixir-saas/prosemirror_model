defmodule ProsemirrorModel.ExtractTest do
  use ExUnit.Case

  alias ProsemirrorModel.Block

  describe "extract_text/1" do
    test "extracts text from a heading" do
      document =
        %Block.Heading{
          attrs: %Block.Heading.Attrs{level: 1},
          content: [
            %Block.Text{text: "hello"},
            %Block.Text{text: "world"}
          ]
        }

      assert ["hello", "world"] = ProsemirrorModel.Extract.extract_text(document)
    end

    test "extracts text from nested blocks" do
      document =
        %{
          content: [
            %Block.Heading{
              attrs: %Block.Heading.Attrs{level: 1},
              content: [%Block.Text{text: "hello"}]
            },
            %Block.Paragraph{
              content: [
                %Block.OrderedList{
                  content: [
                    %Block.ListItem{
                      content: [%Block.Text{text: "nested"}]
                    }
                  ]
                },
                %Block.Text{text: "text"}
              ]
            }
          ]
        }

      assert ["hello", "nested", "text"] = ProsemirrorModel.Extract.extract_text(document)
    end
  end

  describe "extract_blocks/2" do
    test "extracts headings" do
      document =
        %{
          content: [
            %Block.Paragraph{
              content: [
                %Block.Heading{
                  attrs: %Block.Heading.Attrs{level: 1},
                  content: [%Block.Text{text: "h1"}]
                },
                %Block.Text{text: "Heading"}
              ]
            },
            %Block.Paragraph{
              content: [
                %Block.Text{text: "Some leading text"},
                %Block.Heading{
                  attrs: %Block.Heading.Attrs{level: 2},
                  content: [%Block.Text{text: "h2"}]
                }
              ]
            }
          ]
        }

      headings = [
        %Block.Heading{attrs: %Block.Heading.Attrs{level: 1}, content: [%Block.Text{text: "h1"}]},
        %Block.Heading{attrs: %Block.Heading.Attrs{level: 2}, content: [%Block.Text{text: "h2"}]}
      ]

      assert ^headings = ProsemirrorModel.Extract.extract_blocks(document, Block.Heading)
    end
  end
end
