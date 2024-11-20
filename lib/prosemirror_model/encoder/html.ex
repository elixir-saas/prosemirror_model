defprotocol ProsemirrorModel.Encoder.HTML do
  @moduledoc ~S"""
  HTML encoder protocol for ProsemirrorModel structs.

  ## Example implementation

      alias ProsemirrorModel.Encoder.HTML, as: HTMLEncoder

      defimpl HTMLEncoder do
        use Phoenix.Component

        def encode(struct, opts) do
          assigns = Map.new(opts)
          ~H"<span class={@class}><%= @inner_content %></span>"
        end
      end

  """

  @doc ~S"""
  Encode the struct to HTML.

  ## Options

  * `inner_content`: Content of the encoded nodes / marks, either a string or safe html.

  """
  def encode(struct, opts \\ [])
end

defimpl ProsemirrorModel.Encoder.HTML, for: List do
  def encode(structs, opts) do
    Enum.map(structs, &ProsemirrorModel.Encoder.HTML.encode(&1, opts))
  end
end

defimpl ProsemirrorModel.Encoder.HTML, for: Atom do
  def encode(struct, _opts), do: Phoenix.HTML.html_escape(struct)
end
