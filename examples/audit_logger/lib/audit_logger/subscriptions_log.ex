defmodule AuditLogger.SubscriptionsLog do
  use Ecto.Schema

  schema "subscriptions_log" do
    field(:event_id, :string)
    field(:subscription_id, :string)
    field(:customer_id, :string)
    field(:status, :string)
    field(:action, :string)
    field(:old_values, :map)
    field(:new_values, :map)

    timestamps()
  end
end
