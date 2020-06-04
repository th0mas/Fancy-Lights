// Main Light control

import React, {useEffect, useState} from 'react'
import {HuePicker} from 'react-color'
import reactCSS from 'reactcss'
import socket from "../socket"

const MainControl = () => {
  const [lightState, setLightState] = useState({})
  const [lightChan, setLightChan] = useState()

  useEffect(() => {

    socket.connect()
    let chan = socket.channel("lights:dioder")

    chan.on("light_state", (resp) => {
  
      setLightState(resp)
    })
    
    chan.join().receive("ok", (response) => {
      setLightState(response)
      setLightChan(chan)
    })

    return () => {
      chan.leave()
    }
  }, [])

  const handleColourChange = (colour) => {
    setLightState({...lightState, colour: colour.hex})
    lightChan.push("light_colour", {colour: colour.hex})
  }

  if (!lightChan) return <h2>Loading...</h2>
  
  return (
    <HuePicker color={lightState.colour} onChange={handleColourChange} width='100%'/>
  )
}

export default MainControl