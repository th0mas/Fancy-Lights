defmodule FancyLightsFirmware.Lifecycle do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_init_arg) do
    case Phoenix.PubSub.subscribe(FancyLights.PubSub, "lifecycle") do
      :ok ->
        {:ok, :running}
      {:error, term} ->
        {:stop, term}
    end
  end

  def handle_info(msg, state) do
    Logger.info(["Recieved Message: ", inspect(msg)])
    Logger.info(["Current state: ", inspect(state)])

    {:noreply, state}
  end
end
