defprotocol Scribe.Encoder do
  @moduledoc """
  A protocol for custom Scribe encoding of data structures.

  If you have a struct, you can derive the implementation of this protocol
  by specifying which fields should be encoded to Scribe:

        @derive {Scribe.Encoder, only: [....]}
        defstruct ...

  It is also possible to encode all fields or skip some fields via the
  `:except` option:

      @derive Scribe.Encoder
      defstruct ...

  > #### Leaking Private Information {: .error}
  >
  > The `:except` approach should be used carefully to avoid
  > accidentally leaking private information when new fields are added.

  Finally, if you don't own the struct you want to encode to Scribe,
  you may use `Protocol.derive/3` placed outside of any module:

      Protocol.derive(Scribe.Encoder, NameOfTheStruct, only: [...])
      Protocol.derive(Scribe.Encoder, NameOfTheStruct)
  """

  @impl true
  defmacro __deriving__(module, opts) do
    fields = module |> Macro.struct_info!(__CALLER__) |> Enum.map(& &1.field)
    fields = fields_to_encode(fields, opts)

    quote do
      defimpl Scribe.Encoder, for: unquote(module) do
        def headers(term) do
          unquote(fields)
        end
      end
    end
  end

  defp fields_to_encode(fields, opts) do
    cond do
      only = Keyword.get(opts, :only) -> only(only, fields)
      except = Keyword.get(opts, :except) -> except(except, fields)
      true -> fields -- [:__struct__]
    end
  end

  defp only(only, fields) do
    case only -- fields do
      [] -> only
      error_keys -> raise ArgumentError, error_msg(error_keys, fields, :only)
    end
  end

  defp except(except, fields) do
    case except -- fields do
      [] ->
        fields -- [:__struct__ | except]

      error_keys ->
        raise ArgumentError, error_msg(error_keys, fields, :except)
    end
  end

  defp error_msg(error_keys, fields, option) do
    "unknown struct fields #{inspect(error_keys)} specified in :#{option}. Expected one of: " <>
      "#{inspect(fields -- [:__struct__])}"
  end

  @doc """
  A function invoked to derive a list of headers from given term.
  """
  @fallback_to_any true
  def headers(term)
end

defimpl Scribe.Encoder, for: Map do
  def headers(value) do
    value
    |> Map.keys()
    |> Enum.sort()
  end
end

defimpl Scribe.Encoder, for: Any do
  def headers(value) when is_struct(value) do
    value
    |> Map.keys()
    |> Enum.sort()
  end

  def headers(value) do
    raise ArgumentError, "expected a map or struct, got: #{inspect(value)}"
  end
end
