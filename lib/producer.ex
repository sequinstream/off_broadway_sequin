defmodule OffBroadwaySequin.Producer do
  @moduledoc """
  A GenStage Producer for Sequin.

  Broadway producer acts as a consumer for the specified Sequin consumer group.

  ## Producer Options

    * `:consumer_group` - Required. Sequin consumer group name.

    * `:base_url` - Optional. The base URL for the Sequin API.
      Defaults to "https://api.sequinstream.com/api".

    * `:token` - Required. The Sequin API authentication token.

  ## Acknowledgements

  Both successful and failed messages are acknowledged by default. Use
  `Broadway.Message.configure_ack/2` to change this behaviour for
  failed messages.
  """

  use GenStage

  alias Broadway.Message
  alias Broadway.Producer
  alias OffBroadwaySequin.Acknowledger
  alias OffBroadwaySequin.SequinClient

  require Logger

  @behaviour Producer

  @impl GenStage
  def init(opts) do
    {:ok, sequin_config} = SequinClient.init(opts)

    state = %{
      demand: 0,
      sequin_client: SequinClient,
      sequin_config: sequin_config
    }

    {:producer, state}
  end

  @impl GenStage
  def handle_demand(incoming_demand, state) do
    handle_receive_messages(%{state | demand: state.demand + incoming_demand})
  end

  @impl GenStage
  def terminate(_reason, _state) do
    :ok
  end

  defp handle_receive_messages(%{demand: demand} = state) when demand > 0 do
    %{sequin_client: client, sequin_config: config} = state

    case client.receive(demand, config) do
      {:ok, messages} ->
        received_count = length(messages)
        new_demand = demand - received_count

        broadway_messages = wrap_received_messages(messages, state)
        new_state = %{state | demand: new_demand}

        {:noreply, broadway_messages, new_state}

      {:error, reason} ->
        Logger.error("Failed to fetch messages from Sequin. Reason: #{inspect(reason)}")
        {:noreply, [], state}
    end
  end

  defp handle_receive_messages(state) do
    {:noreply, [], state}
  end

  defp wrap_received_messages(messages, state) do
    Enum.map(messages, fn message ->
      %Message{
        data: message,
        metadata: %{},
        acknowledger:
          {Acknowledger, {state.sequin_client, state.sequin_config}, %{id: message.ack_id}}
      }
    end)
  end
end
