defmodule ProsemirrorModel.Type.TiptapStarterKit do
  defmacro __using__(opts) do
    marks = [
      :bold,
      :code,
      :italic,
      :strike
    ]

    blocks = [
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
      blocks: Enum.dedup(blocks ++ Keyword.get(opts, :blocks, [])),
      extend: opts[:extend]
    ]

    quote do
      use ProsemirrorModel.Type, unquote(combined_opts)
    end
  end
end
