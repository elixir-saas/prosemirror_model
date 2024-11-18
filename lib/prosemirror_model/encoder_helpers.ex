defmodule ProsemirrorModel.EncoderHelpers do
  def render(%Phoenix.LiveView.Rendered{} = rendered) do
    Phoenix.HTML.raw(Phoenix.HTML.Safe.to_iodata(rendered))
  end
end
