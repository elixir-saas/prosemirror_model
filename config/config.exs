import Config

if config_env() == :test do
  config :prosemirror_model,
    marks_modules: [
      bold: ProsemirrorModel.Mark.Bold,
      italic: ProsemirrorModel.Mark.Italic,
      underline: ProsemirrorModel.Mark.Underline
    ],
    nodes_modules: [
      heading: ProsemirrorModel.Node.Heading,
      image: ProsemirrorModel.Node.Image,
      paragraph: ProsemirrorModel.Node.Paragraph,
      text: ProsemirrorModel.Node.Text
    ],
    extend: [
      paragraph: [with: [:image]]
    ]
end
