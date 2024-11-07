defmodule AuditLoggerTest do
  use ExUnit.Case
  doctest AuditLogger

  test "greets the world" do
    assert AuditLogger.hello() == :world
  end
end
