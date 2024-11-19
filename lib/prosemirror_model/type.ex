defmodule ProsemirrorModel.Type do
  @moduledoc """
  Generates a document schema with top level marks and blocks configured.
  """

  @marks_modules Application.compile_env!(:prosemirror_model, :marks_modules)
  @blocks_modules Application.compile_env!(:prosemirror_model, :blocks_modules)

  defmacro __using__(opts) do
    context = [
      marks: configured_marks(opts[:marks] || []),
      blocks: configured_blocks(opts[:blocks] || []),
      blocks_opts: configured_blocks_opts(opts[:blocks] || []),
      inline: opts[:inline] || false
    ]

    quote do
      use Ecto.Schema
      use ProsemirrorModel

      unquote(type_schema(context))
      unquote(type_changeset(context))

      defimpl ProsemirrorModel.Encoder.HTML do
        def encode(struct, opts) do
          ProsemirrorModel.Encoder.HTML.encode(struct.content, opts)
        end
      end

      defimpl Jason.Encoder do
        def encode(struct, opts) do
          Jason.Encode.map(Map.from_struct(struct), opts)
        end
      end
    end
  end

  def changeset(struct, attrs, opts) do
    changeset =
      struct
      |> Ecto.Changeset.cast(attrs, [])
      |> ProsemirrorModel.ModifierHelper.cast_prosemirror_content(opts)

    if opts[:inline] do
      Ecto.Changeset.update_change(changeset, :content, fn
        [content | _rest] -> [content]
        _otherwise -> []
      end)
    else
      changeset
    end
  end

  ## Private

  defp configured_marks(marks_config) do
    Keyword.take(@marks_modules, marks_config)
  end

  defp configured_blocks(blocks_config) do
    blocks_config =
      Enum.map(blocks_config, fn
        {block_id, _opts} -> block_id
        block_id -> block_id
      end)

    Keyword.take(@blocks_modules, blocks_config)
  end

  def configured_blocks_opts(blocks_config) do
    Keyword.new(blocks_config, fn
      {block_id, opts} -> {block_id, elem(Code.eval_quoted(opts), 0)}
      block_id -> {block_id, []}
    end)
  end

  defp type_schema(context) do
    quote do
      embedded_schema do
        field(:type, :string)
        embedded_prosemirror_content(unquote(context[:blocks]), array: true)
      end
    end
  end

  defp type_changeset(context) do
    with_opts =
      Keyword.new(context[:blocks], fn {name, module} ->
        extra_opts = Keyword.get(context[:blocks_opts], name, [])
        embed_opts = Keyword.merge(extra_opts, marks: context[:marks])

        {name, {module, :changeset, [embed_opts]}}
      end)

    changeset_opts = [with: with_opts, inline: context[:inline]]

    quote do
      def changeset(struct, attrs \\ %{}) do
        struct
        |> Ecto.Changeset.cast(attrs, [:type])
        |> ProsemirrorModel.Type.changeset(attrs, unquote(Macro.escape(changeset_opts)))
      end
    end
  end
end
