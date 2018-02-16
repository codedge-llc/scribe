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
