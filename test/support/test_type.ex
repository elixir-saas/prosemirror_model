defmodule ProsemirrorModel.TestType do
  use ProsemirrorModel.Type,
    inline: false,
    marks: [:bold, :italic, :underline],
    nodes: [{:heading, level: 1..6}, :paragraph, :text]
end
