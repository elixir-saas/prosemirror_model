defmodule ProsemirrorModel do
  @moduledoc """
  Documentation for `ProsemirrorModel`.
  """

  defmacro __using__(_opts) do
    quote do
      import ProsemirrorModel.ModifierHelpers
    end
  end

  defdelegate extract_text(struct), to: ProsemirrorModel.Extract

  defdelegate extract_blocks(struct, module), to: ProsemirrorModel.Extract
end
