ignore? = Code.compiler_options()[:ignore_module_conflict]
Code.compiler_options(ignore_module_conflict: true)
Code.require_file("inspect_overrides/overrides.ex")
Code.compiler_options(ignore_module_conflict: ignore?)
