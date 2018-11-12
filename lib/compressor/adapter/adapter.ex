defmodule Compressor.Adapter do
  def job(module), do: Module.concat(module, Job)

  def url(module) do
    Keyword.get(config(module), :url, nil)
  end

  def token(module) do
    Keyword.get(config(module), :token, nil)
  end

  defp config(module) do
    Application.get_env(:compressor, module)
  end
end
