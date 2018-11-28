defmodule Cineplex.Reels.UpmaruStudio.Encode.Clean do
  @spec perform(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: {:error, :cleaning_failed} | {:ok, :cleaned}
  def perform(path) do
    case File.rm_rf(path) do
      {:ok, _} ->
        Upstream.reset()
        {:ok, :cleaned}

      {:error, _, _} ->
        {:error, :cleaning_failed}
    end
  end
end
