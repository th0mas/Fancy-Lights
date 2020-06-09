// Main Light control

import React, { useEffect, useState } from 'react'
import { HuePicker } from 'react-color'
import reactCSS from 'reactcss'
import socket from "../socket"

const MainControl = () => {
  const [lightState, setLightState] = useState()
  const [lightChan, setLightChan] = useState({})

  const updateLight = (newState) => {
    setLightState(prevState => ({ ...prevState, ...newState }))
  }

  useEffect(() => {

    socket.connect()
    let chan = socket.channel("lights:dioder")

    chan.join().receive("ok", (response) => {
      setLightState(response)
      setLightChan(chan)
    })

    chan.on("light_colour", (resp) => updateLight(resp))
    chan.on("light_on", (resp) => updateLight(resp))
    chan.on("light_off", () => updateLight({ on: false }))

    return () => {
      chan.leave()
    }
  }, [])

  const handleColourChange = (colour) => {
    setLightState({ ...lightState, ...{ colour: colour.hex } })
    lightChan.push("light_colour", { colour: colour.hex })
  }

  if (!lightState) return <h2>Loading...</h2>

  return ( // 
    <> 
    <div className="phx-hero">
      <h2>Lights are currently {lightState.on ? "on" : "off"}</h2>
      { lightState.on 
        ? <button onClick={() => lightChan.push("light_off")}>Turn off</button>
        : <button onClick={() => lightChan.push("light_on")}>Turn on</button>
      }
    </div>
      { lightState.on &&
        <HuePicker color={lightState.colour} onChange={handleColourChange} width='100%' />
      }
    </>
  )
}

export default MainControl