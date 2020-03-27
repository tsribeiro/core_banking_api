defmodule CoreBankingTest do
  use ExUnit.Case
  doctest CoreBanking

  test "greets the world" do
    assert CoreBanking.hello() == :world
  end
end
