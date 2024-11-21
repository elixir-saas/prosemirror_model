defmodule ProsemirrorModel.Changeset do
  @moduledoc ~S"""
  Module helper for Ecto.Changeset.
  """

  @doc ~S"""
  Casts and validates data integrity for an ProsemirrorModel field type.

  ## Examples

      cast_prosemirror(changeset, :title, required: true)
      %Ecto.Changeset{}

  ## Options

  Same options as (`Ecto.Changeset.cast_embed/3`](https://hexdocs.pm/ecto/Ecto.Changeset.html#cast_embed/3).
  """
  def cast_prosemirror(changeset, attrs, field, opts \\ []) when is_atom(field) do
    plain_field = :"#{field}_plain"

    changeset = Ecto.Changeset.cast(changeset, attrs, [plain_field])

    with data when not is_nil(data) <- Ecto.Changeset.get_change(changeset, plain_field),
         {:ok, parsed_data} <- Jason.decode(data) do
      Map.update(changeset, :params, %{}, &Map.put(&1, "#{field}", parsed_data))
    else
      {:error, _reason} ->
        changeset
        |> Map.put(:valid?, false)
        |> Ecto.Changeset.add_error(field, "could not parse input")

      _otherwise ->
        changeset
    end
    |> Ecto.Changeset.cast_embed(field, opts)
    |> update_plain_field(field)
    |> validate_prosemirror(field)
  end

  def update_plain_field(changeset, field) do
    if type_changes = Ecto.Changeset.get_field(changeset, field) do
      plain_value = Jason.encode!(type_changes)
      Ecto.Changeset.put_change(changeset, :"#{field}_plain", plain_value)
    else
      changeset
    end
  end

  @doc ~S"""
  Validates a prosemirror field (returns `:__parent__` errors to the field itself).


  ## Examples

      # Assuming changeset contains an ProsemirrorModel `title` field.
      struct_or_changeset
      |> Ecto.Changeset.cast(%{title: "Invalid Json"}, [])
      |> validate_prosemirror(changeset, :title, required: true)

      %Ecto.Changeset{changes: %{errors: [title: "Invalid json"]}}

  """
  def validate_prosemirror(changeset, field) when is_atom(field) do
    Ecto.Changeset.validate_change(changeset, field, &put_error/2)
  end

  defp put_error(field, changesets) when is_list(changesets) do
    changesets
    |> Enum.map(&put_error(field, &1))
    |> List.flatten()
  end

  defp put_error(field, changeset) do
    changeset
    |> Map.get(:errors, [])
    |> Keyword.pop_values(:__parent__)
    |> elem(0)
    |> Enum.map(&{field, &1})
  end

  @doc """
  Validates that a prosemirror document has content.
  """
  def validate_prosemirror_required(changeset, field) do
    Ecto.Changeset.validate_change(changeset, field, fn field, value ->
      if ProsemirrorModel.Document.empty?(value) do
        [{field, "cannot be blank"}]
      else
        []
      end
    end)
  end
end
