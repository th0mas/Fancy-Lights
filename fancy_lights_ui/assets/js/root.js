import React from 'react'

import Header from './components/header'
import Control from './pages/control'

const Root = () => {
  return (
    <>
    <Header />
    <section className="container">
      <Control />
    </section>
    </>
  )
}

export default Root