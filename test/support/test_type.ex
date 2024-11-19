defmodule ProsemirrorModel.TestType do
  use ProsemirrorModel.Type,
    inline: false,
    marks: [:bold, :italic, :underline],
    blocks: [{:heading, level: 1..6}, :paragraph, :text]
end
