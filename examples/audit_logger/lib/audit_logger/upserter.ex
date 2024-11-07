defmodule AuditLogger.Upserter do
  alias AuditLogger.Repo
  alias OffBroadwaySequin.SequinClient.MessageData


  def process_user_permission_events(events) do
    Repo.transaction(fn ->
      Enum.each(events, fn %MessageData{data: event} ->
        Repo.insert!(
          %AuditLogger.UserPermissionsLog{
            event_id: to_string(event["id"]),
            user_id: event["record"]["user_id"],
            permission: event["record"]["permission"],
            action: event["action"],
            old_values: event["record"],
            new_values: event["changes"]
          },
          on_conflict: [
            set: [
              user_id: event["record"]["user_id"],
              permission: event["record"]["permission"],
              action: event["action"],
              old_values: event["record"],
              new_values: event["changes"]
            ]
          ],
          conflict_target: :event_id
        )
      end)
    end)
  end

  def process_subscription_events(events) do
    Repo.transaction(fn ->
      Enum.each(events, fn %MessageData{data: event} ->
        Repo.insert!(
          %AuditLogger.SubscriptionsLog{
            event_id: to_string(event["id"]),
            subscription_id: to_string(event["record"]["id"]),
            customer_id: event["record"]["customer_id"],
            status: event["record"]["status"],
            action: event["action"],
            old_values: event["record"],
            new_values: event["changes"]
          },
          on_conflict: [
            set: [
              subscription_id: to_string(event["record"]["id"]),
              customer_id: event["record"]["customer_id"],
              status: event["record"]["status"],
              action: event["action"],
              old_values: event["record"],
              new_values: event["changes"]
            ]
          ],
          conflict_target: :event_id
        )
      end)
    end)
  end
end
