defmodule FancyLightsFirmwareTest do
  use ExUnit.Case
  doctest FancyLightsFirmware

  test "greets the world" do
    assert FancyLightsFirmware.hello() == :world
  end
end
