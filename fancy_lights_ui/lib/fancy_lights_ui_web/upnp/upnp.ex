defmodule FancyLightsUiWeb.Upnp do
  use GenServer
  require Logger
  import FancyLightsUiWeb.Upnp.Response, only: [response: 1]

  @port 1900
  @upnp_multicast_addr {239, 255, 255, 250}

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  # Start listening for UPnP discovery requests
  def init(arg) do
    case :gen_udp.open(@port, [
           :binary,
           active: true,
           reuseaddr: true,
           ip: @upnp_multicast_addr,
           multicast_loop: false,
           multicast_ttl: 4,
           add_membership: {@upnp_multicast_addr, {0, 0, 0, 0}}
         ]) do
      {:ok, socket} ->
        Logger.debug("Listening for UPnP Requests")
        {:ok,
         %{socket: socket, host: Keyword.get(arg, :host), endpoint: Keyword.get(arg, :endpoint)}}

      {:error, reason} ->
        Logger.info(inspect(reason))
        {:stop, reason}
    end
  end

  def handle_info({:udp, _socket, ip, _inportno, packet}, state) do
    if String.contains?(packet, "MAN: \"ssdp:discover\"") do
      Logger.debug(["Recieved packet from ", inspect(ip), ["\n"], packet])
      handle_discovery(state)
    end

    {:noreply, state}
  end

  defp handle_discovery(%{socket: socket, host: host, endpoint: endpoint}) do
    packet = response(host <> endpoint)
    Logger.debug(["Responding with packet: \n", packet, " \n-------------\n"])
    :gen_udp.send(socket, {@upnp_multicast_addr, @port}, packet)
  end
end
