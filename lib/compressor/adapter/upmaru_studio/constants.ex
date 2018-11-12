defmodule Compressor.Adapter.UpmaruStudio.Constants do
  defmacro __using__(_) do
    module = Compressor.Adapter.UpmaruStudio

    quote do
      @adapter unquote(module)

      @url Compressor.Adapter.url(unquote(module))
      @token Compressor.Adapter.token(unquote(module))
    end
  end
end
