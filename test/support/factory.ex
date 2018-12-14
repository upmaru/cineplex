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

  def job_factory do
    %Queue.Job{
      object: "some/object.mov",
      resource: "some/resource:1",
      events_callback_url: "https://example.com/media/1/events"
    }
  end
end
