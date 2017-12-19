defmodule Cumulus.Preset do
  defstruct [
    :name,
    :resolution,
    :video,
    :audio,
    :file
  ]

  @type t :: %__MODULE__{
    name: String.t,
    resolution: String.t,
    video: map,
    audio: map,
    file: map
  }
end