defmodule FancyLightsFirmware.Lights.IkeaLights do
  use GenServer
  require Logger
  alias Pigpiox.Pwm

  @colour_component_pins [4, 17, 18] # [R, G, B]
  @default_colour "FFFFFF"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    case Phoenix.PubSub.subscribe(FancyLights.PubSub, "lights:dioder") do
      :ok ->
        init_lights()
        {:ok, %{on: :true, colour: @default_colour}}
      {:error, term} ->
        {:stop, term}
    end
  end

  def handle_info(%{event: "light_colour", payload: %{colour: colour}}, state) do
    change_colour(colour)
    {:noreply, %{ state | colour: colour}}
  end

  def handle_info(%{event: "light_off"}, state) do
    change_colour("000000")
    {:noreply, %{state | on: false}}
  end

  def handle_info(%{event: "light_on"}, state) do
    change_colour("FFFFFF")
    {:noreply, %{state | on: true}}
  end

  def handle_info(cmd, state) do
    Logger.log(:info, ["Unknown cmd: ", inspect(cmd)])

    {:noreply, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def change_colour(hex) do
    hex
    |> String.trim_leading("#")
    |> get_colour_mapping
    |> apply_colour_mapping
  end

  defp get_colour_mapping(colour) do
    colour_list = for <<x::binary-2 <- colour>>, do: x

    val_list =
      colour_list
      |> Enum.map(&Integer.parse(&1, 16))
      |> Enum.map(fn {val, _rem} when is_integer(val) -> val end)

    Logger.log(:info, inspect(val_list))
    val_list
  end

  defp apply_colour_mapping(colours) do
    @colour_component_pins
    |> Enum.zip(colours)
    |> Enum.each(fn {pin, colour} ->
      Pwm.gpio_pwm(pin, colour)
    end)
  end

  defp init_lights() do
    @default_colour
    |> get_colour_mapping()
    |> apply_colour_mapping()
  end

end
