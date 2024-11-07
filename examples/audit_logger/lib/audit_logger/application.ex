defmodule AuditLogger.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuditLogger.Repo,
      {AuditLogger.UserPermissionsPipeline, []},
      {AuditLogger.SubscriptionsPipeline, []}
    ]

    opts = [strategy: :one_for_one, name: AuditLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
