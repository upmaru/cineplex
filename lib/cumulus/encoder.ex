defmodule Cumulus.Encoder do
  @moduledoc """
  Handles the encoding
  """
  import FFmpex
  use FFmpex.Options

  def perform do
    command = 
      FFmpex.new_command 
      |> add_global_option(option_y()) 
      |> add_input_file(Path.expand("~/Movies/episode-024-connecting-to-our-api.mp4")) 
      |> add_output_file(Path.expand("~/Movies/episode-024-connecting-to-our-api_1080p.mp4")) 
        |> add_stream_specifier(stream_type: :video)
          |> add_stream_option(option_s("1920x1080")) 
          |> add_stream_option(option_profile("main"))
          |> add_stream_option(option_b("4M"))
        |> add_stream_specifier(stream_type: :audio)
          |> add_stream_option(option_b("192K"))
          |> add_stream_option(option_ar("44100"))
        |> add_file_option(option_pix_fmt("yuv420p"))
        |> add_file_option(option_maxrate("6M"))
        |> add_file_option(option_bufsize("4M"))
    :ok = execute(command)
  end
end