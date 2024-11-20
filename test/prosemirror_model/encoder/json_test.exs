defmodule ProsemirrorModel.Encoder.JSONTest do
  use ExUnit.Case, async: true

  alias ProsemirrorModel.Node.{
    Blockquote,
    BulletList,
    CodeBlock,
    HardBreak,
    Heading,
    HorizontalRule,
    Image,
    ListItem,
    OrderedList,
    Paragraph,
    Text
  }

  alias ProsemirrorModel.Mark.{Bold, Code, Color, Italic, Link, Strike, Underline}

  describe "blocks" do
    test "encodes blockquote" do
      blockquote =
        %Blockquote{
          content: [%Text{text: "text"}]
        }

      assert encode_decode(blockquote) == %{
               "content" => [%{"marks" => [], "text" => "text", "type" => "text"}],
               "type" => "blockquote"
             }
    end

    test "encodes bullet_list" do
      bullet_list =
        %BulletList{
          content: [
            %ListItem{content: [%Text{text: "a"}]},
            %ListItem{content: [%Text{text: "b"}]}
          ]
        }

      assert encode_decode(bullet_list) == %{
               "content" => [
                 %{
                   "content" => [%{"marks" => [], "text" => "a", "type" => "text"}],
                   "type" => "listItem"
                 },
                 %{
                   "content" => [%{"marks" => [], "text" => "b", "type" => "text"}],
                   "type" => "listItem"
                 }
               ],
               "type" => "bulletList"
             }
    end

    test "encodes code_block" do
      code_block =
        %CodeBlock{
          content: [%Text{text: "x = y + z"}]
        }

      assert encode_decode(code_block) == %{
               "content" => [%{"marks" => [], "text" => "x = y + z", "type" => "text"}],
               "type" => "codeBlock"
             }
    end

    test "encodes hard_break" do
      assert encode_decode(%HardBreak{}) == %{"type" => "hardBreak"}
    end

    test "encodes heading" do
      heading_1 =
        %Heading{
          content: [%Text{text: "heading 1"}],
          attrs: %Heading.Attrs{level: 1}
        }

      heading_2 =
        %Heading{
          content: [%Text{text: "heading 2"}],
          attrs: %Heading.Attrs{level: 2}
        }

      assert encode_decode(heading_1) == %{
               "attrs" => %{"level" => 1},
               "content" => [%{"marks" => [], "text" => "heading 1", "type" => "text"}],
               "type" => "heading"
             }

      assert encode_decode(heading_2) == %{
               "attrs" => %{"level" => 2},
               "content" => [%{"marks" => [], "text" => "heading 2", "type" => "text"}],
               "type" => "heading"
             }
    end

    test "encodes horizontal_rule" do
      assert encode_decode(%HorizontalRule{}) == %{"marks" => [], "type" => "horizontalRule"}
    end

    test "encodes image" do
      image =
        %Image{
          attrs: %Image.Attrs{
            alt: "image alt",
            src: "https://example.com/image.png",
            title: "an image"
          }
        }

      assert encode_decode(image) == %{
               "attrs" => %{
                 "alt" => "image alt",
                 "src" => "https://example.com/image.png",
                 "title" => "an image"
               },
               "type" => "image"
             }
    end

    test "encodes list_item" do
      list_item =
        %ListItem{
          content: [%Text{text: "a list item"}]
        }

      assert encode_decode(list_item) == %{
               "content" => [%{"marks" => [], "text" => "a list item", "type" => "text"}],
               "type" => "listItem"
             }
    end

    test "encodes ordered_list" do
      ordered_list =
        %OrderedList{
          attrs: %OrderedList.Attrs{start: 1},
          content: [
            %ListItem{content: [%Text{text: "a"}]},
            %ListItem{content: [%Text{text: "b"}]}
          ]
        }

      assert encode_decode(ordered_list) == %{
               "content" => [
                 %{
                   "content" => [%{"marks" => [], "text" => "a", "type" => "text"}],
                   "type" => "listItem"
                 },
                 %{
                   "content" => [%{"marks" => [], "text" => "b", "type" => "text"}],
                   "type" => "listItem"
                 }
               ],
               "type" => "orderedList",
               "attrs" => %{"start" => 1}
             }
    end

    test "encodes paragraph" do
      paragraph =
        %Paragraph{
          content: [%Text{text: "a paragraph"}]
        }

      assert encode_decode(paragraph) == %{
               "content" => [%{"marks" => [], "text" => "a paragraph", "type" => "text"}],
               "type" => "paragraph"
             }
    end

    test "encodes text" do
      assert encode_decode(%Text{text: "text"}) == %{
               "marks" => [],
               "text" => "text",
               "type" => "text"
             }
    end
  end

  describe "marks" do
    test "encodes all marks" do
      text_all_marks =
        %Text{
          text: "text",
          marks: [
            %Bold{},
            %Code{},
            %Color{attrs: %Color.Attrs{color: "red"}},
            %Italic{},
            %Link{attrs: %Link.Attrs{href: "https://example.com"}},
            %Strike{},
            %Underline{}
          ]
        }

      assert encode_decode(text_all_marks) == %{
               "marks" => [
                 %{"type" => "bold"},
                 %{"type" => "code"},
                 %{"attrs" => %{"color" => "red"}, "type" => "color"},
                 %{"type" => "italic"},
                 %{"attrs" => %{"href" => "https://example.com"}, "type" => "link"},
                 %{"type" => "strike"},
                 %{"type" => "underline"}
               ],
               "text" => "text",
               "type" => "text"
             }
    end

    test "encodes bold" do
      text_bold =
        %Text{
          text: "bolded",
          marks: [%Bold{}]
        }

      assert encode_decode(text_bold) == %{
               "marks" => [%{"type" => "bold"}],
               "text" => "bolded",
               "type" => "text"
             }
    end

    test "encodes code" do
      text_code =
        %Text{
          text: "x = y + z",
          marks: [%Code{}]
        }

      assert encode_decode(text_code) == %{
               "marks" => [%{"type" => "code"}],
               "text" => "x = y + z",
               "type" => "text"
             }
    end

    test "encodes color" do
      text_color =
        %Text{
          text: "colored",
          marks: [%Color{attrs: %Color.Attrs{color: "red"}}]
        }

      assert encode_decode(text_color) == %{
               "marks" => [%{"attrs" => %{"color" => "red"}, "type" => "color"}],
               "text" => "colored",
               "type" => "text"
             }
    end

    test "encodes italic" do
      text_italic =
        %Text{
          text: "italicized",
          marks: [%Italic{}]
        }

      assert encode_decode(text_italic) == %{
               "marks" => [%{"type" => "italic"}],
               "text" => "italicized",
               "type" => "text"
             }
    end

    test "encodes link" do
      text_link =
        %Text{
          text: "linked",
          marks: [%Link{attrs: %Link.Attrs{href: "https://example.com"}}]
        }

      assert encode_decode(text_link) == %{
               "marks" => [%{"attrs" => %{"href" => "https://example.com"}, "type" => "link"}],
               "text" => "linked",
               "type" => "text"
             }
    end

    test "encodes strike" do
      text_strike =
        %Text{
          text: "strikethrough",
          marks: [%Strike{}]
        }

      assert encode_decode(text_strike) == %{
               "marks" => [%{"type" => "strike"}],
               "text" => "strikethrough",
               "type" => "text"
             }
    end

    test "encodes underline" do
      text_underline =
        %Text{
          text: "underlined",
          marks: [%Underline{}]
        }

      assert encode_decode(text_underline) == %{
               "marks" => [%{"type" => "underline"}],
               "text" => "underlined",
               "type" => "text"
             }
    end
  end

  def encode_decode(struct) do
    Jason.decode!(Jason.encode!(struct))
  end
end
