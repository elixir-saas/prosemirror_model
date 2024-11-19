import Config

if config_env() == :test do
  config :prosemirror_model,
    marks_modules: [
      bold: ProsemirrorModel.Mark.Bold,
      italic: ProsemirrorModel.Mark.Italic,
      underline: ProsemirrorModel.Mark.Underline
    ],
    blocks_modules: [
      heading: ProsemirrorModel.Block.Heading,
      paragraph: ProsemirrorModel.Block.Paragraph,
      text: ProsemirrorModel.Block.Text
    ]
end
