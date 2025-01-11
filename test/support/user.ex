defmodule Scribe.User do
  @moduledoc """
  Example struct implementing the `Scribe.Encoder` protocol.
  """

  @derive {Scribe.Encoder, except: [:inserted_at, :updated_at]}
  defstruct [:id, :username, :email, :inserted_at, :updated_at]
end
