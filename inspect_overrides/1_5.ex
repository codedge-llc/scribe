if Scribe.compile_auto_inspect?() do
  import Kernel, except: [inspect: 1]
  import Inspect.Algebra, warn: false

  defimpl Inspect, for: List do
    def inspect([], opts) do
      color("[]", :list, opts)
    end

    def inspect([head | _rest] = term, opts) when is_map(head) do
      if do_inspect?(term) do
        do_inspect(term, opts)
      else
        Scribe.format(term)
      end
    end

    def inspect(term, opts) do
      do_inspect(term, opts)
    end

    defp do_inspect?(term) do
      Enum.any?(term, &(!is_map(&1))) or not Scribe.auto_inspect?()
    end

    # TODO: Remove :char_list and :as_char_lists handling in 2.0
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
              IO.warn(
                "the :char_lists inspect option is deprecated, use :charlists instead"
              )

              lists_deprecated
          end
        else
          lists
        end

      open = color("[", :list, opts)
      sep = color(",", :list, opts)
      close = color("]", :list, opts)

      cond do
        lists == :as_charlists or
            (lists == :infer and printable?(term, printable_limit)) ->
          inspected =
            case Inspect.BitString.escape(
                   IO.chardata_to_string(term),
                   ?',
                   printable_limit
                 ) do
              {escaped, ""} -> [?', escaped, ?']
              {escaped, _} -> [?', escaped, ?', " ++ ..."]
            end

          IO.iodata_to_binary(inspected)

        keyword?(term) ->
          surround_many(open, term, close, opts, &keyword/2, sep)

        true ->
          surround_many(open, term, close, opts, &to_doc/2, sep)
      end
    end

    @doc false
    def keyword({key, value}, opts) do
      key = color(key_to_binary(key) <> ": ", :atom, opts)
      concat(key, to_doc(value, opts))
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

    @doc false
    def printable?(list), do: printable?(list, :infinity)

    @doc false
    def printable?(_, 0), do: true

    def printable?([char | rest], counter) when char in 32..126,
      do: printable?(rest, decrement(counter))

    def printable?([?\n | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\r | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\t | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\v | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\b | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\f | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\e | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([?\a | rest], counter),
      do: printable?(rest, decrement(counter))

    def printable?([], _counter), do: true
    def printable?(_, _counter), do: false

    @compile {:inline, decrement: 1}
    defp decrement(:infinity), do: :infinity
    defp decrement(counter), do: counter - 1

    ## Private

    defp key_to_binary(key) do
      case Inspect.Atom.inspect(key) do
        ":" <> right -> right
        other -> other
      end
    end
  end

  defimpl Inspect, for: Map do
    def inspect(map, opts) do
      nest(inspect(map, "", opts), 1)
    end

    def inspect(map, name, opts) do
      if Scribe.auto_inspect?() do
        Scribe.format([map])
      else
        map = :maps.to_list(map)
        open = color("%" <> name <> "{", :map, opts)
        sep = color(",", :map, opts)
        close = color("}", :map, opts)
        surround_many(open, map, close, opts, traverse_fun(map, opts), sep)
      end
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
      concat(
        concat(to_doc(key, opts), sep),
        to_doc(value, opts)
      )
    end
  end

  defimpl Inspect, for: Any do
    def inspect(%{__struct__: struct} = map, opts) do
      try do
        struct.__struct__
      rescue
        _ -> Inspect.Map.inspect(map, opts)
      else
        dunder ->
          if :maps.keys(dunder) == :maps.keys(map) do
            pruned =
              if Scribe.auto_inspect?() do
                :maps.remove(:__exception__, map)
              else
                :maps.remove(:__exception__, :maps.remove(:__struct__, map))
              end

            colorless_opts = %{opts | syntax_colors: []}

            Inspect.Map.inspect(
              pruned,
              Inspect.Atom.inspect(struct, colorless_opts),
              opts
            )
          else
            Inspect.Map.inspect(map, opts)
          end
      end
    end
  end
end
