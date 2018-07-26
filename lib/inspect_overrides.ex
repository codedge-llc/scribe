version = System.version() |> Version.parse!()

ignore? = Code.compiler_options()[:ignore_module_conflict]
Code.compiler_options(ignore_module_conflict: true)

case version do
  %{major: 1, minor: 7} ->
    Code.load_file("inspect_overrides/1_6.ex")

  %{major: 1, minor: 6} ->
    Code.load_file("inspect_overrides/1_6.ex")

  %{major: 1, minor: 5} ->
    Code.load_file("inspect_overrides/1_5.ex")
end

Code.compiler_options(ignore_module_conflict: ignore?)
