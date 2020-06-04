defmodule FancyLightsUiWeb.LifecycleController do
  use FancyLightsUiWeb, :controller
  require Logger

def delete(conn, _params) do
  Logger.info("Broadcasting lifecycle - reboot")
  Phoenix.PubSub.broadcast(FancyLights.PubSub, "lifecycle", {:reboot})
  conn
  |> put_flash(:info, "Rebooting soon")
  |> redirect(to: Routes.page_path(conn, :index, ""))
end
end
