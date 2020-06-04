defmodule FancyLightsUiWeb.LightController do
  use FancyLightsUiWeb, :controller
  require Logger

  def new(conn, %{"status" => lights}) do
    case lights do
      "on" ->
        Logger.log(:info, "Broadcasting lights off")
        Phoenix.PubSub.broadcast(FancyLights.PubSub, "lights", %{command: :light_on})

      "off" ->
        Logger.log(:info, "Broadcasting lights off")
        Phoenix.PubSub.broadcast(FancyLights.PubSub, "lights", %{command: :light_off})
    end

    redirect(conn, to: Routes.page_path(conn, :index, ""))
  end

  def update(conn, %{"lights" => %{"colour" => colour}}) do
    Phoenix.PubSub.broadcast(FancyLights.PubSub, "lights", %{
      command: :change_colour,
      colour: String.trim_leading(colour, "#")
    })

    conn
    |> put_flash(:info, "Colour changed")
    |> redirect(to: Routes.page_path(conn, :index, ""))
  end
end
