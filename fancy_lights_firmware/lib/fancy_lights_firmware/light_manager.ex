defmodule FancyLightsFirmware.LightManager do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    case Phoenix.PubSub.subscribe(FancyLights.PubSub, "lights:dioder") do
      :ok ->
        {:ok, %{function: nil, timing: nil, last_cmd: :ok}}
      {:error, term} ->
        {:stop, term}
    end
  end

  def handle_info(%{event: "light_colour", payload: %{colour: colour}}, state) do
    colour
    |> String.trim_leading("#")
    |> FancyLightsFirmware.IkeaLights.change_colour()
    {:noreply, state}
  end

  def handle_info(%{command: :light_off}, state) do
    FancyLightsFirmware.IkeaLights.change_colour("000000")
    {:noreply, state}
  end

  def handle_info(%{command: :light_on}, state) do
    FancyLightsFirmware.IkeaLights.change_colour("FFFFFF")
    {:noreply, state}
  end

  def handle_info(cmd, state) do
    Logger.log(:info, ["Unknown cmd: ", inspect(cmd)])

    {:noreply, state}
  end
end
