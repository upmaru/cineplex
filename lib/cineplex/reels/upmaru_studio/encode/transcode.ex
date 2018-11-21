
defmodule Cineplex.Reels.UpmaruStudio.Encode.Transcode do
  alias Cineplex.Queue.Source.Preset

  import FFmpex
  use FFmpex.Options

  @spec perform(Preset.t(), binary()) :: {:ok, binary()} | {:error, {any(), pos_integer()}}
  def perform(%Preset{name: name, parameters: parameters} = _preset, input_path) do
    output_name = generate_output_name(name, input_path)
    :ok = transcode(input_path, output_name, parameters)
    {:ok, output_name}
  end

  defp transcode(input_file_path, output_file_path, opts) do
    resolution = Map.get(opts, "resolution", "1920x1080")
    video_rate = integer_opt(opts, "video_rate", 4_000_000)
    audio_rate = integer_opt(opts, "audio_rate", 192_000)
    audio_sample = integer_opt(opts, "audio_sample", 44_100)
    max_rate = integer_opt(opts, "max_rate", 6_000_000)
    gop_duration = get_fps(input_file_path) * 2

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
    |> add_file_option(option_preset("veryfast"))
    |> add_file_option(option_g(gop_duration))
    |> add_file_option(option_threads(threads()))
    |> execute
  end

  defp threads() do
    threads_count = System.schedulers_online()
    if threads_count > 1,
      do: threads_count - 1,
      else: 1
  end

  defp new_command_common_options do
    add_global_option(FFmpex.new_command(), option_y())
  end

  defp integer_opt(opts, key, default) do
    value = Map.get(opts, key)
    if is_integer(value), do: value, else: default
  end

  defp get_fps(file_path) do
    [numerator, denominator] =
      file_path
      |> FFprobe.streams()
      |> Enum.map(fn r -> r["r_frame_rate"] end)
      |> List.first()
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    numerator / denominator
  end

  defp generate_output_name(name, file_path) do
    [file_name, extension] =
      file_path
      |> Path.expand()
      |> Path.basename()
      |> String.split(".")

    Enum.join([
      Path.dirname(file_path),
      "/",
      file_name,
      "_",
      name,
      ".",
      extension
    ])
  end
end
