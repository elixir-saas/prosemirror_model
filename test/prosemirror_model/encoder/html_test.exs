defmodule ProsemirrorModel.Encoder.HTMLTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias ProsemirrorModel.Block
  alias ProsemirrorModel.Encoder.HTML

  describe "blocks" do
    test "encodes hard_break" do
      hard_break = %Block.HardBreak{}

      assert rendered_to_string(HTML.encode(hard_break)) == "<br>"
    end
  end
end
