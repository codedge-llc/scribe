# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

**Added**

- Center and right text alignment options ([#16](https://github.com/codedge-llc/scribe/pull/16)).

**Changed**

- Bumped minimum Elixir version to 1.13.

**Removed**

- Removed `Scribe.auto_inspect/1`.
- Removed `Scribe.auto_inspect?/0`.

## v0.10.0 - 2019-05-29

- Added `:device` option to `Scribe.print/2` for printing to a specific device.
  Defaults to `:stdio`

## v0.9.0 - 2019-05-04

- `NoBorder` style added.

## v0.8.2 - 2019-01-17

- Support for Elixir `v1.8`

## v0.8.1 - 2018-07-25

- Support for Elixir `v1.7`

## v0.8.0 - 2019-03-15

- `:compile_auto_inspect` and `:auto_inspect` config options, both default
  to `false`.
- Added `Scribe.auto_inspect/1` for toggling auto inspect.
- Added `Scribe.auto_inspect?/0`.
- Removed `Scribe.enable/0` and `Scribe.disable/0`, replaced with above.
- Removed `Scribe.enabled?/0`, replaced with above.

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

## v0.7.0 - 2018-02-19

- Pseudographics style added.

## v0.6.0 - 2018-02-16

- Overrides Inspect protocol for `List` and `Map`. These types will now
  automatically return in Scribe's table format. Disabled by default.
  with `config :scribe, enable: false` in your Mix config.
- `Scribe.enable`, `Scribe.disable`, and `Scribe.enabled?` added.
- Minimum Elixir version bumped to `1.5`.

## v0.5.1 - 2018-01-06

- Bump pane dependency to v0.2.0.

## v0.5.0 - 2017-03-27

- `@behaviour Scribe.Style` implemented (See `/style` for example adapters)
- Colorized output.
- Default styling no longer separates data rows.
- Tables no longer width-limited unless specified.
