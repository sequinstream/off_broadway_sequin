defmodule AuditLogger.Repo do
  use Ecto.Repo,
    otp_app: :audit_logger,
    adapter: Ecto.Adapters.Postgres
end
