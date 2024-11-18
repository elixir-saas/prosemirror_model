defmodule ProsemirrorModel do
  @moduledoc """
  Documentation for `ProsemirrorModel`.
  """

  defmacro __using__(_opts) do
    quote do
      import ProsemirrorModel.ModifierHelper
    end
  end
end
