defmodule FancyLightsFirmware.Upnp do
  use GenServer
  require Logger
  import FancyLightsFirmware.Upnp.Response, only: [response: 1]

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
         %{socket: socket, endpoint: Keyword.get(arg, :endpoint)}}

      {:error, reason} ->
        Logger.info(inspect(reason))
        {:stop, reason}
    end
  end

  # Handle a UPnP discover packet, i think (?) this is as targeted as we can go
  def handle_info({:udp, socket, ip, _inportno, packet}, state) do
    if String.contains?(packet, "MAN: \"ssdp:discover\"") do
      Logger.debug(["Recieved packet from ", inspect(ip), ["\n"], packet])
      handle_discovery(socket, state.endpoint)
    end

    {:noreply, state}
  end

  defp handle_discovery(socket, endpoint) do
    packet = response(get_wlan_ip() <> endpoint)
    Logger.debug(["Responding with packet: \n", packet, " \n-------------\n"])
    :gen_udp.send(socket, {@upnp_multicast_addr, @port}, packet)
  end

  defp get_wlan_ip do
    :inet.getifaddrs() # There must be a better way to get the device IP
    |> elem(1)         # Had to go to stackoverflow for this one:
    |> Map.new()       # https://stackoverflow.com/questions/62308215/
    |> Map.get("wlan0")
    |> Keyword.get_values(:addr)
    |> Enum.find(&match?({192, 168, _, _}, &1)) # Attempt to match a local ip
    |> :inet.ntoa()
  end
end
