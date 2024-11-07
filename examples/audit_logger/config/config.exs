import Config

config :audit_logger, AuditLogger.Repo,
  database: "audit_logger",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432

config :audit_logger,
  ecto_repos: [AuditLogger.Repo]
