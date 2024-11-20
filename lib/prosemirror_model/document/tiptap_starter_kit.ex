defmodule ProsemirrorModel.Document.TiptapStarterKit do
  defmacro __using__(opts) do
    marks = [
      :bold,
      :code,
      :italic,
      :strike
    ]

    nodes = [
      :blockquote,
      :bulletList,
      :codeBlock,
      :hardBreak,
      :heading,
      :horizontalRule,
      :listItem,
      :orderedList,
      :paragraph,
      :text
    ]

    combined_opts = [
      inline: opts[:inline] || false,
      marks: Enum.dedup(marks ++ Keyword.get(opts, :marks, [])),
      nodes: Enum.dedup(nodes ++ Keyword.get(opts, :nodes, [])),
      extend: opts[:extend]
    ]

    quote do
      use ProsemirrorModel.Document, unquote(combined_opts)
    end
  end
end
