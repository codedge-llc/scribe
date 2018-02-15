defmodule Scribe do
  @moduledoc """
  Pretty-print tables of structs and maps
  """

  alias Scribe.Table

  @type data ::
          []
          | [...]
          | term

  @typedoc ~S"""
  Options for configuring table output.

  - `:colorize` - When `false`, disables colored output. Defaults to `true`
  - `:data` - Defines table headers
  - `:style` - Style callback module. Defaults to `Scribe.Style.Default`
  - `:width` - Defines table width. Defaults to `:infinite`
  """
  @type format_opts :: [
          colorize: boolean,
          data: [...],
          style: module,
          width: integer
        ]

  @doc ~S"""
  Prints a table from given data.

  ## Examples

      iex> print([])
      :ok

      iex> Scribe.print(%{key: :value, test: 1234}, colorize: false)
      +----------+---------+
      | :key     | :test   |
      +----------+---------+
      | :value   | 1234    |
      +----------+---------+
      :ok
  """
  @spec print(data, format_opts) :: :ok
  def print(_results, opts \\ [])
  def print([], _opts), do: :ok

  def print(results, opts) do
    results
    |> format(opts)
    |> IO.puts()
  end

  def console(results, opts \\ nil) do
    results
    |> format(opts)
    |> Pane.console()
  end

  @doc ~S"""
  Prints a table from given data and returns the data.

  Useful for inspecting pipe chains.

  ## Examples

      iex> Scribe.inspect([])
      []

      iex> Scribe.inspect(%{key: :value, test: 1234}, colorize: false)
      +----------+---------+
      | :key     | :test   |
      +----------+---------+
      | :value   | 1234    |
      +----------+---------+
      %{test: 1234, key: :value}
  """
  @spec inspect(term, format_opts) :: term
  def inspect(results, opts \\ []) do
    print(results, opts)
    results
  end

  @doc ~S"""
  Formats data into a printable table string.

  ## Examples

      iex> format([])
      :ok

      iex> format(%{test: 1234}, colorize: false)
      "+---------+\n| :test   |\n+---------+\n| 1234    |\n+---------+\n"
  """
  @spec format([] | [...] | term) :: String.t() | :ok
  def format(_results, opts \\ [])
  def format([], _opts), do: :ok

  def format(results, opts) when not is_list(results) do
    format([results], opts)
  end

  def format(results, opts) do
    keys = fetch_keys(results, opts[:data])

    headers = map_string_values(keys)
    data = Enum.map(results, &map_string_values(&1, keys))

    table = [headers | data]
    Table.format(table, Enum.count(table), Enum.count(keys), opts)
  end

  defp map_string_values(keys), do: Enum.map(keys, &string_value(&1))
  defp map_string_values(row, keys), do: Enum.map(keys, &string_value(row, &1))

  defp string_value(%{name: name, key: _key}) do
    name
  end

  defp string_value(map, %{name: _name, key: key}) when is_function(key) do
    map |> key.()
  end

  defp string_value(map, %{name: _name, key: key}) do
    map |> Map.get(key)
  end

  defp fetch_keys([first | _rest], opts) do
    case opts do
      nil -> fetch_keys(first)
      opts -> process_headers(opts)
    end
  end

  defp process_headers(opts) do
    for opt <- opts do
      case opt do
        {name, key} -> %{name: name, key: key}
        key -> %{name: key, key: key}
      end
    end
  end

  defp fetch_keys(map) do
    map
    |> Map.keys()
    |> process_headers()
  end
end

defimpl Inspect, for: List do
  alias Code.Identifier
  import Inspect.Algebra

  def inspect([], _opts) do
    "[]"
  end
  def inspect([head | _rest] = term, opts) when is_map(head) do
    if Enum.any?(term, &(!is_map(&1))) do
      do_inspect(term, opts)
    else
      Scribe.format(term)
    end
  end

  def do_inspect(term, opts) do
    %Inspect.Opts{
      charlists: lists,
      char_lists: lists_deprecated,
      printable_limit: printable_limit
    } = opts

    lists =
      if lists == :infer and lists_deprecated != :infer do
        case lists_deprecated do
          :as_char_lists ->
            IO.warn(
              "the :char_lists inspect option and its :as_char_lists " <>
                "value are deprecated, use the :charlists option and its " <>
                ":as_charlists value instead"
            )

            :as_charlists

          _ ->
            IO.warn("the :char_lists inspect option is deprecated, use :charlists instead")
            lists_deprecated
        end
      else
        lists
      end

    open = color("[", :list, opts)
    sep = color(",", :list, opts)
    close = color("]", :list, opts)

    cond do
      lists == :as_charlists or (lists == :infer and List.ascii_printable?(term, printable_limit)) ->
        inspected =
          case Identifier.escape(IO.chardata_to_string(term), ?', printable_limit) do
            {escaped, ""} -> [?', escaped, ?']
            {escaped, _} -> [?', escaped, ?', " ++ ..."]
          end

        IO.iodata_to_binary(inspected)

      keyword?(term) ->
        container_doc(open, term, close, opts, &keyword/2, separator: sep, break: :strict)

      true ->
        container_doc(open, term, close, opts, &to_doc/2, separator: sep)
    end
	end

	@doc false
  def keyword({key, value}, opts) do
    key = color(Identifier.inspect_as_key(key), :atom, opts)
    concat(key, concat(" ", to_doc(value, opts)))
  end

  @doc false
  def keyword?([{key, _value} | rest]) when is_atom(key) do
    case Atom.to_charlist(key) do
      'Elixir.' ++ _ -> false
      _ -> keyword?(rest)
    end
  end

  def keyword?([]), do: true
  def keyword?(_other), do: false
end

defimpl Inspect, for: Map do
  import Inspect.Algebra

  def inspect(map, opts) do
    inspect(map, "", opts)
  end

  def inspect(map, name, opts) do
    # map = :maps.to_list(map)
    # open = color("%" <> name <> "{", :map, opts)
    # sep = color(",", :map, opts)
    # close = color("}", :map, opts)
    # container_doc(open, map, close, opts, traverse_fun(map, opts), separator: sep, break: :strict)
    Scribe.format([map])
  end

  defp traverse_fun(list, opts) do
    if Inspect.List.keyword?(list) do
      &Inspect.List.keyword/2
    else
      sep = color(" => ", :map, opts)
      &to_map(&1, &2, sep)
    end
  end

  defp to_map({key, value}, opts, sep) do
    concat(concat(to_doc(key, opts), sep), to_doc(value, opts))
  end
end
