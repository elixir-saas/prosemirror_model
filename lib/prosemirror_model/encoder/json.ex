defmodule ProsemirrorModel.Encoder.JSON do
  @moduledoc """
  Helper module for automatically implementing the `Jason.Encoder` protocol.

  ## Example

      defmodule MyCustomType do
        use ProsemirrorModel.Encoder.JSON, type: :my_custom_type
      end

  """
  defmacro __using__(opts) do
    type = opts[:type] || raise "A type is required to use the module #{__MODULE__}."

    quote do
      defimpl Jason.Encoder do
        def encode(struct, opts) do
          Map.from_struct(struct)
          |> Map.put(:type, unquote(type))
          |> Jason.Encode.map(opts)
        end
      end
    end
  end
end
