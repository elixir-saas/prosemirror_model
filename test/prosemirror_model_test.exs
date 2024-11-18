defmodule ProsemirrorModelTest do
  use ExUnit.Case

  alias ProsemirrorModel.Block

  describe "extract_blocks/2" do
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

    assert ^headings = ProsemirrorModel.extract_blocks(document, Block.Heading)
  end
end
