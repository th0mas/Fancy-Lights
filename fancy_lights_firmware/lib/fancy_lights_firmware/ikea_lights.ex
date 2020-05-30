defmodule FancyLightsFirmware.IkeaLights do
  use GenServer
  require Logger
  alias Pigpiox.Pwm

  @colour_component_pins [4, 17, 18]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    "FFFFFF"
    |> get_colour_mapping()
    |> apply_colour_mapping()
    {:ok, %{queue: nil, state: :on, colour: "FFFFFF"}}
  end

  def handle_cast(%{colour: new_colour} = _msg, state) do
    new_colour
    |> get_colour_mapping()
    |> apply_colour_mapping()

    Logger.log(:info, ["Changed colour to vals: ", inspect(get_colour_mapping(new_colour))])
    {:noreply, %{state | colour: new_colour}}
  end

  def change_colour(colour) when is_binary(colour) do
    GenServer.cast(__MODULE__, %{colour: colour})
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

end
