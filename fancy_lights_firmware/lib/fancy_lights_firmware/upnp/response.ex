defmodule FancyLightsFirmware.Upnp.Response do
  require EEx

  # Apparently this is the response needed to imitate a Philips hub
  @template "HTTP/1.1 200 OK
CACHE-CONTROL: max-age=86400
EXT:
LOCATION: <%= location %>
OPT: \"http://schemas.upnp.org/upnp/1/0/\"; ns=01
ST: urn:schemas-upnp-org:device:basic:1
USN: uuid:Socket-1_0-221438K0100073::urn:Belkin:device:**"

  # Creates response/1 at compile time
  EEx.function_from_string(:def, :response, @template, [:location])
end
