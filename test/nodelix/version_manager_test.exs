defmodule Nodelix.VersionManagerTest do
  use ExUnit.Case, async: true

  setup do
    :ets.new(:test_state, [:set, :public, :named_table])
    :ok
  end

  @version "14.0.0"
  @archive_base_url "https://nodejs.org/dist"

  test "fetch_archive handles max retries exceeded" do
    fetch_impl = fn _url ->
      raise "Simulated failure"
    end

    assert {:error, :max_retries_exceeded} =
             Nodelix.VersionManager.fetch_archive(
               @version,
               @archive_base_url,
               2,
               fetch_impl
             )
  end

  test "fetch_archive succeeds after a few retries" do
    :ets.insert(:test_state, {:fails_remaining, 2})

    fetch_impl = fn _url ->
      [{:fails_remaining, fails}] = :ets.lookup(:test_state, :fails_remaining)

      if fails > 0 do
        :ets.insert(:test_state, {:fails_remaining, fails - 1})
        raise "Simulated failure"
      else
        "Simulated success"
      end
    end

    assert :ok =
             Nodelix.VersionManager.fetch_archive(
               @version,
               @archive_base_url,
               3,
               fetch_impl
             )
  end

  test "fetch_archive succeeds immediately" do
    fetch_impl = fn _url -> "simulated success" end

    assert :ok =
             Nodelix.VersionManager.fetch_archive(
               @version,
               @archive_base_url,
               3,
               fetch_impl
             )
  end
end
