defmodule OffBroadwaySequin.Acknowledger do
  @moduledoc false
  @behaviour Broadway.Acknowledger

  @impl true
  def ack(_, [], _failed) do
    :ok
  end

  def ack({sequin_client, sequin_config}, successful, _failed) do
    ack_ids =
      Enum.map(successful, fn
        %{acknowledger: {_, _ack_ref, ack_data}} -> ack_data.id
      end)

    sequin_client.ack(ack_ids, sequin_config)
  end

  # @impl true
  # def configure(_ack_ref, ack_data, options) do
  #   case options do
  #     [retry: value] when is_boolean(value) ->
  #       {:ok, %{ack_data | retry: value}}

  #     _ ->
  #       {:error, "Invalid options, options must be keyword list with `:retry`"}
  #   end
  # end
end
