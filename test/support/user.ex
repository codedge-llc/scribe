defmodule Scribe.User do
  @derive {Scribe.Encoder, except: [:inserted_at, :updated_at]}
  defstruct [:id, :username, :email, :inserted_at, :updated_at]
end
