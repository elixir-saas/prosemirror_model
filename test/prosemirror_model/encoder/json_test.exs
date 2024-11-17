defmodule ProsemirrorModel.Encoder.JSONTest do
  use ExUnit.Case, async: true

  alias ProsemirrorModel.Block

  describe "blocks" do
    test "encodes hard_break" do
      hard_break = %Block.HardBreak{}

      assert Jason.encode!(hard_break) == "{\"type\":\"hard_break\"}"
    end
  end
end
