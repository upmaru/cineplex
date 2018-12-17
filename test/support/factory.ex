defmodule Cineplex.Factory do
  use ExMachina.Ecto, repo: Cineplex.Repo

  alias Cineplex.Queue

  @spec source_factory() :: Cineplex.Queue.Source.t()
  def source_factory do
    %Queue.Source{
      endpoint: "https://example.com",
      token: "blah",
      reel: "upmaru_studio"
    }
  end

  @spec job_factory() :: Cineplex.Queue.Job.t()
  def job_factory do
    %Queue.Job{
      object: "some/object.mov",
      resource: "some/resource:1",
      events_callback_url: "https://example.com/media/1/events"
    }
  end

  @spec job_entry_factory() :: Cineplex.Queue.Job.Entry.t()
  def job_entry_factory do
    %Queue.Job.Entry{
      job: build(:job),
      preset: build(:preset)
    }
  end

  @spec preset_factory() :: Cineplex.Queue.Source.Preset.t()
  def preset_factory do
    %Queue.Source.Preset{
      name: "example"
    }
  end
end
