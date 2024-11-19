defmodule ProsemirrorModel do
  @moduledoc """
  Documentation for `ProsemirrorModel`.
  """

  defmacro __using__(_opts) do
    quote do
      import ProsemirrorModel.ModifierHelpers
    end
  end

  @doc """
  Extracts blocks of a particular module from a document tree.
  """
  def extract_blocks(%block_module{} = block, block_module) do
    [block]
  end

  def extract_blocks(%{content: content}, block_module) when is_list(content) do
    Enum.flat_map(content, &extract_blocks(&1, block_module))
  end

  def extract_blocks(_otherwise, _block_module), do: []
end
