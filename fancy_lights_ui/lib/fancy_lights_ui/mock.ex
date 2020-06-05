defmodule FancyLightsUi.Mock do
  use GenServer
  require Logger
  # A mock lighting module for testing.
  @mock_module_name FancyLightsFirmware.Lights.IkeaLights
  @default_colour "FFFFFF"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: @mock_module_name)
  end

  def init(_opts) do
    case Phoenix.PubSub.subscribe(FancyLights.PubSub, "lights:dioder") do
      :ok ->
        {:ok, %{on: :true, colour: @default_colour}}
      {:error, term} ->
        {:stop, term}
    end
  end

  def handle_info(%{event: "light_colour", payload: %{colour: colour}}, state) do
    {:noreply, %{ state | colour: colour}}
  end

  def handle_info(%{event: "light_off"}, state) do
    {:noreply, %{state | on: false}}
  end

  def handle_info(%{event: "light_on"}, state) do
    {:noreply, %{state | on: true}}
  end

  def handle_info(cmd, state) do
    Logger.log(:info, ["Unknown cmd: ", inspect(cmd)])

    {:noreply, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
