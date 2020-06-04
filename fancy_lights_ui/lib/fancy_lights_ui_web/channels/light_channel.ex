defmodule FancyLightsUiWeb.LightChannel do
  use FancyLightsUiWeb, :channel
  require Logger

  def join("lights:dioder", _params, socket) do
    {:ok, %{on: :true, colour: "#FFFFFF"}, socket}
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
end
