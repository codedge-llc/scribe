if Scribe.compile_auto_inspect?() do
  import Kernel, except: [inspect: 1]
  import Inspect.Algebra, warn: false

  defimpl Inspect, for: List do
    alias Code.Identifier

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

    def do_inspect(term, opts) do
      %Inspect.Opts{
        charlists: lists,
        printable_limit: printable_limit
      } = opts

      open = color("[", :list, opts)
      sep = color(",", :list, opts)
      close = color("]", :list, opts)

      cond do
        lists == :as_charlists or
            (lists == :infer and List.ascii_printable?(term, printable_limit)) ->
          inspected =
            case Identifier.escape(
                   IO.chardata_to_string(term),
                   ?',
                   printable_limit
                 ) do
              {escaped, ""} -> [?', escaped, ?']
              {escaped, _} -> [?', escaped, ?', " ++ ..."]
            end

          IO.iodata_to_binary(inspected)

        keyword?(term) ->
          container_doc(
            open,
            term,
            close,
            opts,
            &keyword/2,
            separator: sep,
            break: :strict
          )

        true ->
          container_doc(open, term, close, opts, &to_doc/2, separator: sep)
      end
    end

    @doc false
    def keyword({key, value}, opts) do
      key = color(Macro.inspect_atom(:key, key), :atom, opts)
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
      if Scribe.auto_inspect?() do
        Scribe.format([map])
      else
        map = :maps.to_list(map)
        open = color("%" <> name <> "{", :map, opts)
        sep = color(",", :map, opts)
        close = color("}", :map, opts)

        container_doc(
          open,
          map,
          close,
          opts,
          traverse_fun(map, opts),
          separator: sep,
          break: :strict
        )
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
      concat(concat(to_doc(key, opts), sep), to_doc(value, opts))
    end
  end

  defimpl Inspect, for: Any do
    def inspect(struct, opts) when is_struct(struct) do
      pruned =
        if Scribe.auto_inspect?() do
          Map.drop(struct, [:__exception__])
        else
          Map.drop(struct, [:__exception__, :__struct__])
        end

      colorless_opts = %{opts | syntax_colors: []}

      Inspect.Map.inspect(pruned, colorless_opts)
    end

    def inspect(map, opts)  do
      Inspect.Map.inspect(map, opts)
    end
  end
end
