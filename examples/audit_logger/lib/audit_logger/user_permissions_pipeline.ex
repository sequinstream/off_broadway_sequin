defmodule AuditLogger.UserPermissionsPipeline do
  use Broadway

  alias Broadway.Message
  alias AuditLogger.Upserter

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          OffBroadwaySequin.Producer,
          consumer:
            System.get_env("SEQUIN_USER_PERMISSIONS_CONSUMER", "user_permission_events_group"),
          token: System.fetch_env!("SEQUIN_TOKEN"),
          base_url: System.get_env("SEQUIN_BASE_URL")
        }
      ],
      processors: [
        default: [
          concurrency: 5,
          max_demand: 100
        ]
      ],
      batchers: [
        default: [
          batch_size: 100,
          batch_timeout: 1000,
          concurrency: 5
        ]
      ]
    )
  end

  @impl true
  def handle_message(_processor, message, _context) do
    message
    |> Message.put_batcher(:default)
  end

  @impl true
  def handle_batch(:default, messages, _batch_info, _context) do
    events = Enum.map(messages, & &1.data)
    Upserter.process_user_permission_events(events)
    messages
  end
end
