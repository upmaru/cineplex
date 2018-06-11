defmodule CompressorTest do
  use ExUnit.Case
  doctest Compressor

  test "greets the world" do
    assert Compressor.hello() == :world
  end
end
