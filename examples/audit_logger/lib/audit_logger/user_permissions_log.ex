defmodule AuditLogger.UserPermissionsLog do
  use Ecto.Schema

  schema "user_permissions_log" do
    field(:event_id, :string)
    field(:user_id, :string)
    field(:permission, :string)
    field(:action, :string)
    field(:old_values, :map)
    field(:new_values, :map)

    timestamps()
  end
end
