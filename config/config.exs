# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :cumulus, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:cumulus, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
config :blazay, Blazay,
  account_id: System.get_env("B2_ACCOUNT_ID"),
  application_key: System.get_env("B2_APPLICATION_KEY"),
  bucket_id: System.get_env("B2_BUCKET_ID"),
  bucket_name: System.get_env("B2_BUCKET_NAME"),
  concurrency: 2

config :cumulus, :presets, 
[[
  resolution: "1920x1080",
  video_rate: 4_000_000,
  audio_rate: 192_000,
  audio_sample: 44100,
  max_rate: 6_000_000,
  name: "1080p"
  ], [
  resolution: "1280x720",
  video_rate: 2_000_000,
  audio_rate: 128_000,
  audio_sample: 44100,
  max_rate: 4_000_000,
  name: "720p"
  ], [
  resolution: "1024x576",
  video_rate: 1_000_000,
  audio_rate: 96_000,
  audio_sample: 44100,
  max_rate: 2_000_000,
  name: "576p"
  ], [
  resolution: "640x360",
  video_rate: 500_000,
  audio_rate: 64_000,
  audio_sample: 44100,
  max_rate: 1_000_000,
  name: "360p"
  ]
]
