# ProsemirrorModel

An Elixir implementation of ProseMirror's [document model](https://prosemirror.net/docs/ref/#model) for Ecto.
Uses [`:polymorphic_embed`](https://github.com/mathieuprog/polymorphic_embed) to represent documents.
Inspired by [`:ex_prosemirror`](https://github.com/Omerlo-Technologies/ex_prosemirror).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `prosemirror_model` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:prosemirror_model, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/prosemirror_model>.

