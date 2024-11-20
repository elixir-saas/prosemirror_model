defmodule ProsemirrorModel.Extract do
  @doc """
  Extracts a list of strings from all text nodes.
  """
  def extract_text(%ProsemirrorModel.Block.Text{text: text}) do
    [text]
  end

  def extract_text(%{content: content}) when is_list(content) do
    Enum.flat_map(content, &extract_text/1)
  end

  def extract_text(_otherwise), do: []

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
