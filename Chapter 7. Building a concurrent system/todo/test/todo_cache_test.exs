defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache} = Todo.Cache.start()
    test_pid = Todo.Cache.server_process(cache, "test")

    assert test_pid != Todo.Cache.server_process(cache, "other")
    assert test_pid == Todo.Cache.server_process(cache, "test")
  end

  test "to-do operations" do
    {:ok, cache} = Todo.Cache.start()
    test_pid = Todo.Cache.server_process(cache, "test")
    Todo.Server.add_entry(test_pid, %{date: ~D[2021-02-23], title: "Test"})
    entries = Todo.Server.entries(test_pid, ~D[2021-02-23])

    assert [%{date: ~D[2021-02-23], title: "Test"}] = entries
  end
end
