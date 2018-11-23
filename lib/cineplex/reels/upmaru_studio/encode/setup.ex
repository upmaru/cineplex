defmodule Cineplex.Reels.UpmaruStudio.Encode.Setup do
  alias Cineplex.Queue.Job
  alias Upstream.B2

  @spec perform(Job.t()) :: {:error, :setup_failed} | {:ok, binary(), binary()}
  def perform(%Job{object: object, source: source} = _job) do
    with {:ok, [_apps]} <- Upstream.set_config(to_keyword_list(source.storage)),
         {:ok, auth} <- get_authorization_key(object),
         {:ok, path} <- setup_tmp_directory(object),
         url when is_binary(url) <- get_download_url(object, auth) do
      {:ok, url, path}
    else
      _ -> {:error, :setup_failed}
    end
  end

  defp setup_tmp_directory(object) do
    path = "tmp/" <> object

    :ok =
      path
      |> Path.dirname()
      |> File.mkdir_p()

    {:ok, path}
  end

  defp get_authorization_key(object) do
    object
    |> String.split("/")
    |> List.first()
    |> B2.Download.authorize(3600)
  end

  defp get_download_url(object, %{authorization_token: token} = _auth),
    do: B2.Download.url(object, token)

  defp to_keyword_list(config) do
    config
    |> Enum.into([])
    |> Enum.map(fn {key, value} ->
      {String.to_atom(key), value}
    end)
  end
end
