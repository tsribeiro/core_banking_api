defmodule CoreBankingServerTest do
  use ExUnit.Case
  doctest CoreBankingServer

  test "greets the world" do
    assert CoreBankingServer.hello() == :world
  end
end
