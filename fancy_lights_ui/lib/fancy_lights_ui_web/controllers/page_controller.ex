defmodule FancyLightsUiWeb.PageController do
  use FancyLightsUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
