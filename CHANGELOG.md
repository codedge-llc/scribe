# v0.8.0
* `:compile_auto_inspect` and `:auto_inspect` config options, both default
  to false
* Added `Scribe.auto_inspect/1` for toggling auto inspect
* Added `Scribe.auto_inspect?/0`
* Removed `Scribe.enable/0` and `Scribe.disable/0`, replaced with above
* Removed `Scribe.enabled?/0`, replaced with above

To work with production releases, auto-inspect functionality can now be
optionally compiled (not compiled by default). To enable auto-inspect for
your development environment, add this to your `config/dev.exs`:

    config :scribe,
      compile_auto_inspect: true,
      auto_inspect: true

To temporarily disable auto-inspect in your shell, use
`Scribe.auto_inspect(false)`. Inspect will work as normal until set to
true again.

If auto-inspect is not compiled (or disabled), `Scribe.print/2` and similar
functions will continue to work as normal.

# v0.7.0
* Pseudographics style added

# v0.6.0
* Overrides Inspect protocol for `List` and `Map`. These types will now
  automatically return in Scribe's table format. Disable by default
  with `config :scribe, enable: false` in your Mix config.
* `Scribe.enable`, `Scribe.disable`, and `Scribe.enabled?` added
* Minimum Elixir version bumped to `1.5`

# v0.5.1
* Bump pane dependency to v0.2.0

# v0.5.0
* `@behaviour Scribe.Style` implemented (See `/style` for example adapters)
* Colorized output
* Default styling no longer separates data rows
* Tables no longer width-limited unless specified
