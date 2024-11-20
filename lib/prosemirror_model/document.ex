defmodule ProsemirrorModel.Document do
  @moduledoc """
  Generates a document schema with top level marks and nodes configured.
  """

  @marks_modules Application.compile_env(:prosemirror_model, :marks_modules, [])
  @nodes_modules Application.compile_env(:prosemirror_model, :nodes_modules, [])

  defmacro __using__(opts) do
    context = [
      marks: configured_marks(opts[:marks] || []),
      nodes: configured_nodes(opts[:nodes] || []),
      nodes_opts: configured_nodes_opts(opts[:nodes] || []),
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
      |> ProsemirrorModel.ModifierHelpers.cast_prosemirror_content(opts)

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

  defp configured_nodes(nodes_config) do
    nodes_config =
      Enum.map(nodes_config, fn
        {node_id, _opts} -> node_id
        node_id -> node_id
      end)

    Keyword.take(@nodes_modules, nodes_config)
  end

  def configured_nodes_opts(nodes_config) do
    Keyword.new(nodes_config, fn
      {node_id, opts} -> {node_id, elem(Code.eval_quoted(opts), 0)}
      node_id -> {node_id, []}
    end)
  end

  defp type_schema(context) do
    quote do
      embedded_schema do
        field(:type, :string)
        embedded_prosemirror_content(unquote(context[:nodes]), array: true)
      end
    end
  end

  defp type_changeset(context) do
    with_opts =
      Keyword.new(context[:nodes], fn {name, module} ->
        extra_opts = Keyword.get(context[:nodes_opts], name, [])
        embed_opts = Keyword.merge(extra_opts, marks: context[:marks])

        {name, {module, :changeset, [embed_opts]}}
      end)

    changeset_opts = [with: with_opts, inline: context[:inline]]

    quote do
      def changeset(struct, attrs \\ %{}) do
        struct
        |> Ecto.Changeset.cast(attrs, [:type])
        |> ProsemirrorModel.Document.changeset(attrs, unquote(Macro.escape(changeset_opts)))
      end
    end
  end
end
