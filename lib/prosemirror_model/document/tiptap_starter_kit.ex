defmodule ProsemirrorModel.Document.TiptapStarterKit do
  defmacro __using__(opts) do
    # Allowed marks
    marks = [
      :bold,
      :code,
      :italic,
      :strike
    ]

    # Allowed top-level nodes
    nodes = [
      :blockquote,
      :bulletList,
      :codeBlock,
      :heading,
      :horizontalRule,
      :orderedList,
      :paragraph
    ]

    combined_opts = [
      inline: opts[:inline] || false,
      marks: Enum.dedup(marks ++ Keyword.get(opts, :marks, [])),
      nodes: Enum.dedup(nodes ++ Keyword.get(opts, :nodes, []))
    ]

    quote do
      use ProsemirrorModel.Document, unquote(combined_opts)
    end
  end
end
