defmodule AuditLogger.Repo.Migrations.CreateAuditTables do
  use Ecto.Migration

  def change do
    create table(:user_permissions_log) do
      add :event_id, :text, null: false
      add :user_id, :text, null: false
      add :permission, :text, null: false
      add :action, :text, null: false
      add :old_values, :map
      add :new_values, :map

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_permissions_log, [:event_id])
    create index(:user_permissions_log, [:user_id])

    create table(:subscriptions_log) do
      add :event_id, :text, null: false
      add :subscription_id, :text, null: false
      add :customer_id, :text, null: false
      add :status, :text, null: false
      add :action, :text, null: false
      add :old_values, :map
      add :new_values, :map

      timestamps(type: :utc_datetime)
    end

    create unique_index(:subscriptions_log, [:event_id])
    create index(:subscriptions_log, [:subscription_id])
    create index(:subscriptions_log, [:customer_id])
  end
end
