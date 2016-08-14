use Mix.Config
alias Dogma.Rule

config :dogma,
  rule_set: Dogma.RuleSet.All,
  override: [
    %Rule.LineLength{ max_length: 100 }
  ]
