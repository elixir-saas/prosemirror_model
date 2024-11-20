defmodule ProsemirrorModel.Extract do
  @doc """
  Extracts a list of strings from all text nodes.
  """
  def extract_text(%ProsemirrorModel.Node.Text{text: text}) do
    [text]
  end

  def extract_text(%{content: content}) when is_list(content) do
    Enum.flat_map(content, &extract_text/1)
  end

  def extract_text(_otherwise), do: []

  @doc """
  Extracts nodes of a particular module from a document tree.
  """
  def extract_nodes(%node_module{} = node, node_module) do
    [node]
  end

  def extract_nodes(%{content: content}, node_module) when is_list(content) do
    Enum.flat_map(content, &extract_nodes(&1, node_module))
  end

  def extract_nodes(_otherwise, _node_module), do: []
end
