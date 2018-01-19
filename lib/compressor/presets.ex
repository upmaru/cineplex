defmodule Compressor.Presets do
  @moduledoc """
  A Collection of presets
  """

  import FFmpex
  use FFmpex.Options

  def streamable(input_file_path, output_file_path, opts \\ %{}) do
    resolution = Map.get(opts, "resolution", "1920x1080")
    video_rate = integer_opt(opts, "video_rate", 4_000_000)
    audio_rate = integer_opt(opts, "audio_rate", 192_000)
    audio_sample = integer_opt(opts, "audio_sample", 44_100)
    max_rate = integer_opt(opts, "max_rate", 6_000_000)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
    |> add_stream_specifier(stream_type: :video)
    |> add_stream_option(option_s(resolution))
    |> add_stream_option(option_profile("main"))
    |> add_stream_option(option_b(video_rate))
    |> add_stream_option(option_bufsize(2 * video_rate))
    |> add_stream_specifier(stream_type: :audio)
    |> add_stream_option(option_b(audio_rate))
    |> add_stream_option(option_ar(audio_sample))
    |> add_stream_option(option_bufsize(2 * audio_rate))
    |> add_file_option(option_pix_fmt("yuv420p"))
    |> add_file_option(option_maxrate(max_rate))
    |> add_file_option(option_movflags("faststart"))
    |> execute
  end

  defp new_command_common_options do
    add_global_option(FFmpex.new_command(), option_y())
  end

  def integer_opt(opts, key, default) do
    value = Map.get(opts, key)
    if is_integer(value), do: value, else: default
  end
end
