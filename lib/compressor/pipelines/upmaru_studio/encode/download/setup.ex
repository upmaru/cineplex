defmodule Compressor.Pipelines.UpmaruStudio.Encode.Download.Setup do
  alias Upstream.B2

  @spec perform(binary()) :: {:error, atom()} | {:ok, binary(), binary()}
  def perform(name) do
    with {:ok, auth} <- get_authorization_key(name),
         {:ok, path} <- setup_tmp_directory(name),
         url when is_binary(url) <- get_download_url(name, auth) do
      {:ok, url, path}
    else
      _ -> {:error, :setup_failed}
    end
  end

  defp setup_tmp_directory(name) do
    path = ("tmp/" <> name)

    :ok =
      path
      |> Path.dirname()
      |> File.mkdir_p()

    {:ok, path}
  end

  defp get_authorization_key(name) do
    name
    |> String.split("/")
    |> List.first()
    |> B2.Download.authorize(3600)
  end

  defp get_download_url(name, %{authorization_token: token} = _auth) do
    B2.Download.url(name, token)
  end
end
