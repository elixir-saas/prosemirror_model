defmodule ProsemirrorModel.Encoder.HTMLTest do
  use ExUnit.Case, async: true

  alias ProsemirrorModel.Block.{
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

  alias ProsemirrorModel.Encoder.HTML

  describe "special cases" do
    test "nil" do
      assert render_to_string(nil) == ""
    end

    test "atom" do
      assert render_to_string(:something) == "something"
    end
  end

  describe "blocks" do
    test "encodes blockquote" do
      blockquote =
        %Blockquote{
          content: [%Text{text: "text"}]
        }

      assert render_to_string(blockquote) == "<blockquote>text</blockquote>"
    end

    test "encodes bullet_list" do
      bullet_list =
        %BulletList{
          content: [
            %ListItem{content: [%Text{text: "a"}]},
            %ListItem{content: [%Text{text: "b"}]}
          ]
        }

      assert render_to_string(bullet_list) == "<ul><li>a</li><li>b</li></ul>"
    end

    test "encodes code_block" do
      code_block =
        %CodeBlock{
          content: [%Text{text: "x = y + z"}]
        }

      assert render_to_string(code_block) == "<pre><code>x = y + z</code></pre>"
    end

    test "encodes hard_break" do
      assert render_to_string(%HardBreak{}) == "<br>"
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

      assert render_to_string(heading_1) == "<h1>heading 1</h1>"
      assert render_to_string(heading_2) == "<h2>heading 2</h2>"
    end

    test "encodes horizontal_rule" do
      assert render_to_string(%HorizontalRule{}) == "<hr>"
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

      assert render_to_string(image) ==
               ~S|<img alt="image alt" src="https://example.com/image.png" title="an image">|
    end

    test "encodes list_item" do
      list_item =
        %ListItem{
          content: [%Text{text: "a list item"}]
        }

      assert render_to_string(list_item) == "<li>a list item</li>"
    end

    test "encodes ordered_list" do
      ordered_list =
        %OrderedList{
          content: [
            %ListItem{content: [%Text{text: "a"}]},
            %ListItem{content: [%Text{text: "b"}]}
          ]
        }

      assert render_to_string(ordered_list) == "<ol><li>a</li><li>b</li></ol>"
    end

    test "encodes paragraph" do
      paragraph =
        %Paragraph{
          content: [%Text{text: "a paragraph"}]
        }

      assert render_to_string(paragraph) == "<p>a paragraph</p>"
    end

    test "encodes text" do
      assert render_to_string(%Text{text: "text"}) == "text"
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

      assert render_to_string(text_all_marks) ==
               ~S|<strong><code><span style="color: red;"><em><a href="https://example.com"><s><u>text</u></s></a></em></span></code></strong>|
    end

    test "encodes bold" do
      text_bold =
        %Text{
          text: "bolded",
          marks: [%Bold{}]
        }

      assert render_to_string(text_bold) == "<strong>bolded</strong>"
    end

    test "encodes code" do
      text_code =
        %Text{
          text: "x = y + z",
          marks: [%Code{}]
        }

      assert render_to_string(text_code) == "<code>x = y + z</code>"
    end

    test "encodes color" do
      text_color =
        %Text{
          text: "colored",
          marks: [%Color{attrs: %Color.Attrs{color: "red"}}]
        }

      assert render_to_string(text_color) == ~S|<span style="color: red;">colored</span>|
    end

    test "encodes italic" do
      text_italic =
        %Text{
          text: "italicized",
          marks: [%Italic{}]
        }

      assert render_to_string(text_italic) == "<em>italicized</em>"
    end

    test "encodes link" do
      text_link =
        %Text{
          text: "linked",
          marks: [%Link{attrs: %Link.Attrs{href: "https://example.com"}}]
        }

      assert render_to_string(text_link) == ~S|<a href="https://example.com">linked</a>|
    end

    test "encodes strike" do
      text_strike =
        %Text{
          text: "strikethrough",
          marks: [%Strike{}]
        }

      assert render_to_string(text_strike) == "<s>strikethrough</s>"
    end

    test "encodes underline" do
      text_underline =
        %Text{
          text: "underlined",
          marks: [%Underline{}]
        }

      assert render_to_string(text_underline) == "<u>underlined</u>"
    end
  end

  defp render_to_string(doc) do
    Phoenix.LiveViewTest.rendered_to_string(HTML.encode(doc))
  end
end
