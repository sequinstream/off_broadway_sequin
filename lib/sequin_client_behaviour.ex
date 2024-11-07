defmodule OffBroadwaySequin.SequinClientBehaviour do
  @moduledoc """
  A generic behaviour to implement Sequin Clients for `OffBroadwaySequin.Producer`.
  """

  alias Broadway.Message

  @type messages :: [Message.t()]

  @callback init(opts :: any) :: {:ok, normalized_opts :: any} | {:error, reason :: binary}
  @callback receive_messages(demand :: pos_integer, opts :: any) :: messages
end
