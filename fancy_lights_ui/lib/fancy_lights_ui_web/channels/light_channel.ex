defmodule FancyLightsUiWeb.LightChannel do
  use FancyLightsUiWeb, :channel
  require Logger

  @light_module FancyLightsFirmware.Lights.IkeaLights

  def join("lights:dioder", _params, socket) do
    state = get_current_light_state()
    {:ok, state, socket}
  end

  def handle_in("light_colour", %{"colour" => colour}, socket) do
    # Phoenix.PubSub.broadcast(FancyLights.PubSub, "lights", %{
    #   command: :change_colour,
    #   colour: String.trim_leading(colour, "#")
    # })

    broadcast(socket, "light_colour", %{
      colour: colour
    })
    {:noreply, socket}
  end

  def get_current_light_state() do
    GenServer.call(@light_module, :get_state)
  end
end
