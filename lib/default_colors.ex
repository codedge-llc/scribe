defmodule Scribe.DefaultColors do
  @moduledoc false

  # Defines default colors for printing. These are the same as IEx defaults.

  defmacro __using__(_) do
    quote do
      def default_color(), do: IO.ANSI.default_color()

      def color(value) when is_boolean(value), do: IO.ANSI.magenta()
      def color(value) when is_nil(value), do: IO.ANSI.magenta()
      def color(value) when is_number(value), do: IO.ANSI.yellow()
      def color(value) when is_binary(value), do: IO.ANSI.green()
      def color(value) when is_atom(value), do: IO.ANSI.cyan()
      def color(_value), do: IO.ANSI.default_color()
    end
  end
end
