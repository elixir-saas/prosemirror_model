defmodule ProsemirrorModel.TestDocument do
  use ProsemirrorModel.Document,
    inline: false,
    marks: [:bold, :italic, :underline],
    nodes: [{:heading, level: 1..6}, :paragraph, :text]
end
