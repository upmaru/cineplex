defmodule Cineplex.Queue.Job.Entry.ScopeTest do
  use ExUnit.Case, async: true

  alias Cineplex.Queue

  import Cineplex.Factory

  describe "source not live" do
    setup do
      source = insert(:source, endpoint: "https://notlive.com", live: false)
      preset = insert(:preset, source: source)

      job = insert(:job, source: source)
      job_entry = insert(:job_entry, job: job, preset: preset)

      {:ok, %{job_entry: job_entry}}
    end

    test "waiting scope should not include entries from source not live", %{job_entry: job_entry} do
      job_entries = Queue.get_job_entries(:waiting)

      job_entry_ids = Enum.map(job_entries, fn j -> j.id end)

      refute Enum.member?(job_entry_ids, job_entry.id)
    end
  end

  describe "source is live" do
    setup do
      source = insert(:source, endpoint: "https://islive.com", live: true)
      preset = insert(:preset, source: source)

      job = insert(:job, resource: "test/live/source:1", source: source)
      job_entry = insert(:job_entry, job: job, preset: preset)

      {:ok, %{job_entry: job_entry}}
    end

    test "waiting scope should include entries from live source", %{job_entry: job_entry} do
      job_entries = Queue.get_job_entries(:waiting)

      job_entry_ids = Enum.map(job_entries, fn j -> j.id end)

      assert Enum.member?(job_entry_ids, job_entry.id)
    end
  end
end
